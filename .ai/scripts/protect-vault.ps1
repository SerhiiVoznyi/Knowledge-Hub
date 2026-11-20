<#
.SYNOPSIS
  One-time setup that keeps private vault content out of git.

.DESCRIPTION
  - Points git at the tracked hooks in .githooks/, whose pre-commit hook refuses
    commits that add or change files in the private vault folders.
  - Marks the published skeleton pages (folder indexes and dashboards) as
    skip-worktree, so local edits that list people, clients, or meetings are never staged.

  Run it once after cloning, from anywhere inside the repository.
  Use -Undo before intentionally editing the published skeleton (or pulling skeleton changes),
  then run the script again.
#>
param([switch]$Undo)

$ErrorActionPreference = 'Stop'
Set-Location (git rev-parse --show-toplevel)

$privateFolders = 'meetings', 'people', 'projects', 'decisions', 'notes', 'tasks', 'journal', 'dashboards', 'inbox'
$skeleton = git ls-files -- $privateFolders | Where-Object { $_ -notmatch '(^|/)\.gitkeep$' }

if ($Undo) {
    git update-index --no-skip-worktree -- $skeleton
    Write-Host "Skeleton pages are editable in git again ($($skeleton.Count) files). Rerun without -Undo when done."
    return
}

git config core.hooksPath .githooks
git update-index --skip-worktree -- $skeleton

Write-Host "Hooks path set to .githooks."
Write-Host "Protected $($skeleton.Count) skeleton pages with skip-worktree:"
$skeleton | ForEach-Object { Write-Host "  $_" }
