<#
.SYNOPSIS
  Read-only structure check for Knowledge-Hub notes (see .ai/skills/md-note-structure/SKILL.md).
.EXAMPLE
  pwsh .ai/skills/validate-note/check-note.ps1 dotnet/EF_Core_Interview_Cheat_Sheet.md
.EXAMPLE
  pwsh .ai/skills/validate-note/check-note.ps1          # checks every tracked note
#>
param([string[]]$Path)

$ErrorActionPreference = 'Stop'
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
# Non-ASCII characters are built from code points so the script works without a BOM in Windows PowerShell 5.1.
$backLink = '[' + [char]0x2191 + ' Content](#content)'

function Get-Slug([string]$text) {
    $s = $text.Trim().ToLowerInvariant()
    $s = [regex]::Replace($s, '[^\p{L}\p{M}\p{N}\p{Pc} \-]', '')
    return $s.Replace(' ', '-')
}

function Test-Note([string]$file) {
    $findings = New-Object System.Collections.Generic.List[string]
    $lines = Get-Content -LiteralPath $file -Encoding UTF8

    $headings = @()
    $inFence = $false
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match '^\s*(```|~~~)') { $inFence = -not $inFence; continue }
        if (-not $inFence -and $lines[$i] -match '^(#{1,6}) (.+?)\s*#*\s*$') {
            $headings += [pscustomobject]@{ Level = $matches[1].Length; Text = $matches[2]; Index = $i }
        }
    }

    $seen = @{}
    foreach ($h in $headings) {
        $base = Get-Slug $h.Text
        $slug = if ($seen.ContainsKey($base)) { "$base-$($seen[$base])" } else { $base }
        $seen[$base] = 1 + [int]$seen[$base]
        $h | Add-Member -NotePropertyName Slug -NotePropertyValue $slug
    }
    $slugs = @{}
    $headings | ForEach-Object { $slugs[$_.Slug] = $true }

    $h1 = @($headings | Where-Object Level -eq 1)
    if ($h1.Count -eq 0 -or $h1[0].Index -ne 0) { $findings.Add('Line 1 is not the H1 title.') }
    foreach ($h in ($h1 | Select-Object -Skip 1)) {
        if ($h.Text -notmatch '^Part ') { $findings.Add("Line $($h.Index + 1): extra H1 that is not a part divider: '$($h.Text)'.") }
    }

    $content = $headings | Where-Object { $_.Level -eq 2 -and $_.Text -eq 'Content' } | Select-Object -First 1
    if (-not $content) {
        $findings.Add("Missing '## Content' section.")
        return $findings
    }

    $tocEnd = $lines.Count
    $next = $headings | Where-Object { $_.Index -gt $content.Index } | Select-Object -First 1
    if ($next) { $tocEnd = $next.Index }
    $tocAnchors = New-Object System.Collections.Generic.List[string]
    for ($i = $content.Index + 1; $i -lt $tocEnd; $i++) {
        foreach ($m in [regex]::Matches($lines[$i], '\]\(#([^)]+)\)')) {
            $a = $m.Groups[1].Value
            $tocAnchors.Add($a)
            if (-not $slugs.ContainsKey($a)) { $findings.Add("Line $($i + 1): Content link '#$a' does not match any heading.") }
        }
    }

    $body = @($headings | Where-Object { $_.Index -gt $content.Index -and $_.Level -in 2, 3 })
    foreach ($h in $body) {
        if (-not $tocAnchors.Contains($h.Slug)) { $findings.Add("Line $($h.Index + 1): heading not listed in Content: '$($h.Text)'.") }
    }

    $bodyOrder = @($body | ForEach-Object Slug | Where-Object { $tocAnchors.Contains($_) })
    $tocOrder = @($tocAnchors | Where-Object { $slugs.ContainsKey($_) -and $bodyOrder -contains $_ })
    if (($bodyOrder -join '|') -ne ($tocOrder -join '|')) { $findings.Add('Content entries are not in document order.') }

    foreach ($h in $body) {
        $j = $h.Index + 1
        while ($j -lt $lines.Count -and $lines[$j].Trim() -eq '') { $j++ }
        if ($j -ge $lines.Count) { $findings.Add("Line $($h.Index + 1): '$($h.Text)' has no body."); continue }
        $nextLine = $lines[$j].Trim()
        if ($nextLine -eq $backLink) { continue }
        if ($h.Level -eq 2 -and $nextLine -match '^### ') { continue }
        $findings.Add("Line $($h.Index + 1): missing '$backLink' under '$($h.Text)'.")
    }

    $readme = Join-Path $repoRoot 'README.md'
    $relative = $file.Substring($repoRoot.Length).TrimStart('\', '/').Replace('\', '/')
    if ($relative -ne 'README.md' -and -not (Select-String -LiteralPath $readme -SimpleMatch "]($relative)" -Quiet)) {
        $findings.Add("Not listed in README.md catalog as ']($relative)'.")
    }

    return $findings
}

if (-not $Path) {
    Push-Location $repoRoot
    try {
        $Path = git ls-files '*.md' | Where-Object { $_ -ne 'README.md' -and $_ -ne 'AGENTS.md' -and $_ -notlike '.ai/*' }
    } finally { Pop-Location }
    $Path = $Path | ForEach-Object { Join-Path $repoRoot $_ }
}

$failed = 0
foreach ($p in $Path) {
    $full = (Resolve-Path -LiteralPath $p).Path
    $findings = Test-Note $full
    $name = $full.Substring($repoRoot.Length).TrimStart('\', '/')
    if ($findings.Count -eq 0) {
        Write-Output "PASS  $name"
    } else {
        $failed++
        Write-Output "FAIL  $name ($($findings.Count))"
        $findings | ForEach-Object { Write-Output "      $_" }
    }
}
exit [int]($failed -gt 0)
