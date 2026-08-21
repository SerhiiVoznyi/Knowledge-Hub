# .NET 10 Multithreading Interview Cheat Sheet

A consolidated interview reference for **multithreading, concurrency, parallelism, and asynchronous programming** in **C# 14 / .NET 10**. It emphasizes the mechanism behind each API, the trade-offs, and the failure modes interviewers expect you to recognize.

> Version note: C# 14 ships with .NET 10, but it adds no concurrency primitive of its own. The modern `System.Threading.Lock` integration was introduced in C# 13 / .NET 9 and remains the recommended in-process mutual-exclusion mechanism in .NET 10.

---

## Content

1. [How to Use This Guide](#how-to-use-this-guide)
2. [Core Mental Models](#core-mental-models)
   - [Concurrency, Parallelism, Asynchrony](#c1-concurrency-parallelism-and-asynchrony)
   - [Process, Thread, ThreadPool, Task](#c2-process-thread-threadpool-and-task)
   - [CPU-Bound vs I/O-Bound](#c3-cpu-bound-vs-io-bound)
   - [Shared Mutable State](#c4-shared-mutable-state)
   - [Atomicity, Visibility, Ordering](#c5-atomicity-visibility-and-ordering)
   - [The .NET Memory Model](#c6-the-net-memory-model)
3. [Synchronization and Coordination](#synchronization-and-coordination)
   - [`Lock` and `lock`](#s1-systemthreadinglock-and-lock)
   - [`Monitor`](#s2-monitor)
   - [`Interlocked`, `Volatile`, and `volatile`](#s3-interlocked-volatile-and-volatile)
   - [Semaphores and Mutexes](#s4-semaphores-and-mutexes)
   - [Reader/Writer Locks](#s5-readerwriterlockslim)
   - [Events, Barrier, CountdownEvent](#s6-events-barrier-and-countdownevent)
   - [Spin Primitives](#s7-spin-primitives)
   - [Primitive Selection](#s8-primitive-selection)
4. [Tasks, Async, and Parallelism](#tasks-async-and-parallelism)
   - [`Task` and `Task.Run`](#t1-task-and-taskrun)
   - [`async` / `await`](#t2-async-and-await)
   - [`WhenAll`, `WhenAny`, and `WhenEach`](#t3-taskwhenall-taskwhenany-and-taskwheneach)
   - [Cancellation](#t4-cooperative-cancellation)
   - [Exceptions](#t5-task-exceptions)
   - [`ValueTask`](#t6-valuetask)
   - [Parallel Loops and PLINQ](#t7-parallel-loops-and-plinq)
   - [Bounded Concurrency](#t8-bounded-concurrency)
   - [`TaskCompletionSource`](#t9-taskcompletionsource)
   - [SynchronizationContext and ConfigureAwait](#t10-synchronizationcontext-and-configureawait)
   - [`IAsyncEnumerable<T>`](#t11-iasyncenumerablet)
   - [`IAsyncDisposable`](#t12-iasyncdisposable)
   - [ExecutionContext and `AsyncLocal<T>`](#t13-executioncontext-and-asynclocalt)
5. [Collections, Channels, and Safer Designs](#collections-channels-and-safer-designs)
6. [Junior Interview Questions](#junior-interview-questions)
7. [Mid-Level Interview Questions](#mid-level-interview-questions)
8. [Senior Interview Questions](#senior-interview-questions)
9. [Async / Await Interview Questions](#async--await-interview-questions)
   - [Junior (0-2 Years)](#async-junior-0-2-years)
     - [What is async and await in C#?](#aj1-what-is-async-and-await-in-c)
     - [Synchronous vs asynchronous code](#aj2-what-is-the-difference-between-synchronous-and-asynchronous-code)
     - [What happens when an async method is called?](#aj3-what-happens-when-an-async-method-is-called)
     - [`Task`, `Task<T>`, and `ValueTask`](#aj4-what-is-task-taskt-and-valuetask)
     - [`Task.Run` vs async/await](#aj5-what-is-the-difference-between-taskrun-and-asyncawait)
     - [`Task.Delay` vs `Thread.Sleep`](#aj6-what-is-the-difference-between-await-taskdelay-and-threadsleep)
     - [Why avoid `.Result` and `.Wait()`](#aj7-why-should-you-avoid-result-and-wait-on-async-tasks)
     - [How async/await avoids blocking](#aj8-how-does-asyncawait-avoid-blocking-threads)
     - [`async void` vs `async Task` vs `async Task<T>`](#aj9-what-is-the-difference-between-async-void-async-task-and-async-taskt)
     - [What happens if you don't await a Task?](#aj10-what-happens-if-you-dont-await-a-task)
   - [Mid (2-5 Years)](#async-mid-2-5-years)
     - [`WhenAll`, `WhenAny`, `WhenEach`](#am1-what-is-the-difference-between-taskwhenall-taskwhenany-and-taskwheneach)
     - [Exceptions in async code](#am2-how-do-you-handle-exceptions-in-async-code)
     - [Timeouts](#am3-how-do-you-implement-a-timeout-for-an-async-operation)
     - [`CancellationToken`](#am4-what-is-cancellationtoken-and-how-do-you-use-it-in-async-methods)
     - [Avoiding async deadlocks](#am5-how-do-you-avoid-deadlocks-in-async-code)
     - [`IAsyncEnumerable<T>` vs `IEnumerable<T>`](#am6-explain-iasyncenumerablet-and-how-it-differs-from-ienumerablet)
     - [CPU-bound vs I/O-bound](#am7-what-is-the-difference-between-cpu-bound-and-io-bound-operations-in-async-programming)
     - [Optimizing an async method](#am8-how-would-you-optimize-performance-in-an-async-method)
     - [When `ValueTask` is better](#am9-what-is-the-purpose-of-valuetask-and-when-is-it-better-than-task)
     - [How async/await works under the hood](#am10-how-does-asyncawait-work-under-the-hood-in-net)
   - [Senior (5+ Years)](#async-senior-5-years)
     - [ThreadPool and async/await](#as1-how-does-the-threadpool-work-with-asyncawait)
     - [`ConfigureAwait` in library vs app code](#as2-explain-configureawaittrue-vs-configureawaitfalse-in-library-vs-application-code)
     - [Scalable async API design](#as3-how-do-you-design-a-highly-scalable-async-api)
     - [Pitfalls of async over sync](#as4-what-are-the-potential-pitfalls-of-using-async-over-sync)
     - [Backpressure in an async stream](#as5-how-would-you-handle-backpressure-in-an-async-stream)
     - [ASP.NET Core request pipeline](#as6-explain-how-asyncawait-interacts-with-the-aspnet-core-request-pipeline)
     - [Diagnosing async performance issues](#as7-how-do-you-diagnose-and-troubleshoot-performance-issues-in-async-applications)
     - [`IAsyncDisposable` and `await using`](#as8-what-is-iasyncdisposable-and-when-should-you-use-await-using)
     - [Retries with exponential backoff](#as9-how-would-you-handle-retries-with-exponential-backoff-in-async-code)
     - [ExecutionContext flow](#as10-explain-how-executioncontext-flows-with-asyncawait-and-how-to-control-it)
10. [Failure Modes and Diagnostics](#failure-modes-and-diagnostics)
11. [Common Anti-Patterns](#common-anti-patterns)
12. [Rapid Interview Answers](#rapid-interview-answers)
13. [Self-Check Checklist](#self-check-checklist)
14. [Glossary](#glossary)

---

## How to Use This Guide

[↑ Content](#content)

- **Junior:** Explain threads, tasks, races, `lock`, cancellation, and CPU-bound vs I/O-bound work. For async: what `await` does, `Task` vs `ValueTask`, why `.Result`/`Wait()` are unsafe, and what happens if a task is never awaited.
- **Mid:** Choose primitives, compose tasks, bound concurrency, and diagnose deadlocks or starvation. For async: `WhenAll`/`WhenAny`/`WhenEach`, timeouts, `IAsyncEnumerable<T>`, and exception flow.
- **Senior:** Explain memory ordering, safe publication, scheduling, contention, diagnostics, and architecture that minimizes shared state. For async: ThreadPool interaction, `ConfigureAwait`, ExecutionContext, backpressure, ASP.NET Core pipeline, and retries.

Answer interview questions in this order:

1. **Define** the concept in one sentence.
2. **Explain the mechanism** that makes it work.
3. **Name a trade-off or failure mode.**
4. **Give a short production example.**

The best multithreading answer is often not “add a lock.” First ask whether ownership, immutability, partitioning, or message passing can remove shared mutable state.

---

## Core Mental Models

### C1. Concurrency, Parallelism, and Asynchrony

[↑ Content](#content)

| Concept | Definition | Mechanism that makes it work | .NET 10 example |
|---|---|---|---|
| **Concurrency** | A *structural* property: several logical operations are in flight during overlapping time windows, not necessarily at the same instant | A scheduler interleaves whichever operations are ready to run; progress comes from switching, so a single core is enough | Kestrel serving thousands of connections on 8 cores |
| **Parallelism** | An *execution* property: several operations run at the same instant on different cores | Work is split into independent chunks; each chunk gets a thread that the OS places on its own core | `Parallel.For` over image tiles |
| **Asynchrony** | A *control-flow* property: the caller regains control before the operation finishes and resumes later through a continuation | The compiler rewrites the method into a state machine; the completion source (IOCP/epoll, timer, `TaskCompletionSource`) drives the next step when the result arrives | `await stream.ReadAsync(buffer, ct)` |
| **Multithreading** | An *implementation* choice: one process runs several OS threads | Each thread owns a stack and register context; the OS scheduler time-slices them across available cores | ThreadPool workers draining the work queue |

The same program can use all four, and each solves a different problem:

```csharp
// Asynchrony: the calling thread is released while the OS completes the read.
await using FileStream file = File.OpenRead(path);
int read = await file.ReadAsync(buffer, ct);

// Concurrency: three operations overlap in time; one thread can serve all three.
Task<User> user = LoadUserAsync(id, ct);
Task<Order[]> orders = LoadOrdersAsync(id, ct);
Task<Offer[]> offers = LoadOffersAsync(id, ct);
await Task.WhenAll(user, orders, offers);

// Parallelism: pure CPU work split across cores.
Parallel.For(0, tiles.Length, i => tiles[i] = Sharpen(tiles[i]));
```

They are related, not interchangeable:

- Async I/O may use **no thread** while the device or OS is handling the request.
- Concurrent operations may take turns on **one core**.
- Parallel CPU work requires multiple threads and available cores.
- Adding threads does not make inherently sequential work faster.

**Interview line:** `async` is about non-blocking coordination; parallelism is about simultaneous execution.

---

### C2. Process, Thread, ThreadPool, and Task

[↑ Content](#content)

| Abstraction | Definition | Who schedules it | What it costs | Choose it when |
|---|---|---|---|---|
| **Process** | An isolated address space with its own memory, handles, and runtime instance | The OS | Highest: separate memory and startup; communication requires IPC or the network | You need fault or security isolation, or independent deployment and restart |
| **Thread** | An OS-scheduled execution path with a private stack and register context | The OS scheduler; you control creation and lifetime | About 1 MB of reserved stack on Windows by default, plus kernel bookkeeping; every context switch discards warm CPU state | A long-lived blocking loop, a dedicated pump, or a specific apartment state or priority |
| **ThreadPool** | A runtime-managed set of reusable workers with one global queue plus a local queue per worker | The runtime; workers beyond `ThreadPool.MinThreads` (default `Environment.ProcessorCount`) are injected gradually | Almost nothing per work item, but the pool is a shared finite resource that every library competes for | Short CPU work, continuations, and timer callbacks |
| **Task** | A *promise object* holding the eventual completion state, result, exception, and cancellation of an operation | Nobody by itself: it is state plus a continuation list; a `TaskScheduler` is involved only when there is a delegate to run | One small heap allocation, avoidable with `ValueTask` on hot paths | You need to compose, await, or propagate the outcome of any operation |

```csharp
// Dedicated thread: a long blocking loop that must not occupy a pool worker.
Thread pump = new(DrainDeviceQueue) { IsBackground = true, Name = "device-pump" };
pump.Start();

// ThreadPool: short CPU work; the pool owns the thread and reuses it afterwards.
int checksum = await Task.Run(() => ComputeChecksum(block), ct);

// Tasks that never touch a thread: already complete, or completed by someone else.
ValueTask<int> cached = ValueTask.FromResult(42);
TaskCompletionSource<Message> tcs = new(TaskCreationOptions.RunContinuationsAsynchronously);
```

A `Task` is **not a thread**. It may represent:

- CPU work running on a ThreadPool thread
- asynchronous I/O with no thread blocked
- an already-completed result
- an externally completed operation via `TaskCompletionSource`

Prefer tasks and higher-level APIs. Create `Thread` directly only when you need a dedicated long-running thread, priority/affinity-like control, a specific apartment state, or isolation from ThreadPool scheduling.

.NET 10 made the pool more forgiving: when a worker is about to block, its local queue is flushed to the global queue so other workers can steal that work. This removes one class of self-inflicted stall, but it does not make sync-over-async safe — a captured `SynchronizationContext` still deadlocks, and blocked workers still consume the pool.

---

### C3. CPU-Bound vs I/O-Bound

[↑ Content](#content)

| Work | Definition | How to recognize it | Preferred pattern | Cost of misclassifying |
|---|---|---|---|---|
| **I/O-bound** | Elapsed time is dominated by waiting for a device or remote peer, while the CPU has nothing to do | A thread performing it would sit in a wait state; a faster CPU barely changes latency | Call the naturally async API and `await` it; scale by raising concurrency, never by adding threads | Wrapping a *synchronous* I/O call in `Task.Run` parks one worker per outstanding request and leads to ThreadPool starvation |
| **CPU-bound** | Elapsed time is dominated by executing instructions, so the work scales with core count | A profiler shows the method on-CPU; wall time drops when cores are added | Run it directly; use `Task.Run` only to keep a caller responsive (typically UI); use `Parallel`/PLINQ once each chunk is large enough to pay for scheduling | `await` cannot make computation cheaper; awaiting it on the UI thread still freezes the window |
| **Mixed** | Async I/O followed by non-trivial computation over the result | Both a network wait and a measurable post-processing step appear in the trace | Await the I/O, then parallelize only the CPU stage that measurement proved expensive | Parallelizing the whole pipeline multiplies open connections, sockets, and peak memory for no CPU gain |

```csharp
// I/O-bound: no extra worker thread is needed while waiting.
var json = await httpClient.GetStringAsync(uri, cancellationToken);

// CPU-bound: useful in a UI app; usually unnecessary in ASP.NET Core request code.
var digest = await Task.Run(
    () => ComputeDigest(data, cancellationToken),
    cancellationToken);
```

`Task.Run` around an async I/O method consumes a worker only to begin work that was already non-blocking. It adds scheduling overhead and does not improve scalability.

---

### C4. Shared Mutable State

[↑ Content](#content)

A race exists when correctness depends on unpredictable timing between concurrent accesses and at least one access mutates state.

```csharp
private int _count;

public void UnsafeIncrement()
{
    _count++; // read → add → write; not one atomic operation
}
```

Two threads can both read `10`, both compute `11`, and both write `11`. One update is lost.

Naming the *kind* of race is what separates a confident answer from “add a lock”:

| Race | Definition | Concrete failure | Fix |
|---|---|---|---|
| **Lost update** | Two read-modify-write sequences interleave, so the later write is based on a stale read | Two `_count++` calls on 10 produce 11 instead of 12 | `Interlocked.Increment`, or one lock around the whole update |
| **Check-then-act** | A decision is taken on state that another thread changes before the action runs | `if (!dict.ContainsKey(k)) dict.Add(k, v)` throws or overwrites | An atomic API such as `TryAdd`/`GetOrAdd`, or a lock spanning both steps |
| **Torn read or write** | A value wider than the platform's atomic unit, or a multi-field struct, is observed half-updated | A `struct Range(int Lo, int Hi)` is read with the old `Lo` and the new `Hi` | Publish an immutable object by reference, or lock both fields together |
| **Unsafe publication** | A reference becomes visible before the object it points to is fully initialized | A reader sees a non-null instance whose fields still hold defaults | `Volatile.Write`, `Interlocked.Exchange`, a lock, or `Lazy<T>` |
| **Broken invariant** | Every field is individually thread-safe, but the relationship between them is not | `Balance` is updated atomically while `LastTransactionId` is still the previous one | One lock, or one immutable snapshot covering the whole invariant |

Safer designs, in preferred order — earlier entries remove the problem, later entries only manage it:

| # | Strategy | Definition | .NET 10 example | Trade-off |
|---|---|---|---|---|
| 1 | **Locality** | State lives inside one operation and never escapes it | A local accumulator inside a method; no field is touched | Only works when nothing must outlive the call |
| 2 | **Immutability** | Values never change after construction, so readers cannot observe a transition | `record` or `ImmutableArray<T>` shared freely across threads | Every update allocates a new instance |
| 3 | **Ownership** | Exactly one component may mutate the state; everyone else sends it messages | A single-reader `Channel<T>` in front of a `BackgroundService` | Adds a hop and a queue you must bound |
| 4 | **Partitioning** | State is split so that no two workers touch the same slice | Per-worker buckets merged once at the end | Requires a partitioning key and a merge step |
| 5 | **Atomics and concurrent collections** | Individual operations are indivisible and correctly ordered | `Interlocked.Add`, `ConcurrentDictionary<K,V>` | Atomic per operation only, never per workflow |
| 6 | **Locking** | Mutual exclusion around the smallest coherent invariant | `lock` over a private `System.Threading.Lock` | Contention, and deadlock risk once locks nest |

```csharp
// 2. Immutable: any number of threads may read this snapshot without a lock.
public sealed record PricingRules(decimal Vat, ImmutableArray<string> ExemptSkus);

// 4. Partitioning: no shared counter on the hot path, one merge at the end.
long total = source
    .AsParallel()
    .Aggregate(0L, (subtotal, item) => subtotal + item.Bytes, (a, b) => a + b, x => x);

// 5. Atomic: correct for one independent value, not for a multi-field invariant.
Interlocked.Add(ref _bytesWritten, count);
```

---

### C5. Atomicity, Visibility, and Ordering

[↑ Content](#content)

Thread safety requires more than “the value fits in one machine word.”

| Property | Definition | Question to ask | Symptom when it is missing | Provided by |
|---|---|---|---|---|
| **Atomicity** | An operation is observed as indivisible: no thread can see a state between its start and its end | Can another thread observe a partial operation? | Lost updates and torn values | `Interlocked.*`, `lock`, swapping one immutable reference |
| **Visibility** | A write made by one thread becomes observable to another at a defined point instead of “eventually, maybe” | When does another thread observe the write? | A reader loops forever on a value cached in a register or in the core's store buffer | `Volatile.Read`/`Volatile.Write`, `volatile`, lock exit and entry, `Interlocked` |
| **Ordering** | Operations become visible to other threads in an order that program logic can rely on | Can compiler or CPU reordering expose an invalid sequence? | A reader sees the “ready” flag before the data that flag advertises | Acquire/release semantics from the same primitives, or a full fence |

`Interlocked.Increment` provides an atomic read-modify-write operation and appropriate memory ordering:

```csharp
private int _count;

public int Increment() => Interlocked.Increment(ref _count);
```

Visibility is the property that fails silently in Debug and breaks in Release. The JIT is allowed to hoist a non-volatile read out of a loop, because within a single thread nothing changes it:

```csharp
private bool _stop;                                   // may be read once and cached
public void Run() { while (!_stop) DoWork(); }        // can loop forever
public void Stop() => _stop = true;

// Correct: an acquire load each iteration, paired with a release store.
private bool _stopFlag;
public void RunSafely() { while (!Volatile.Read(ref _stopFlag)) DoWork(); }
public void RequestStop() => Volatile.Write(ref _stopFlag, true);
```

In real code, use a `CancellationToken` instead of a hand-rolled flag: it carries the correct ordering, composes with async APIs, and supports callbacks and linked sources.

Atomic fields do not automatically make a multi-field invariant atomic. If `Balance` and `LastTransactionId` must change together, protect the whole transition or publish one immutable snapshot.

---

### C6. The .NET Memory Model

[↑ Content](#content)

Each thread may observe cached values, and compilers/CPUs may reorder operations when single-threaded behavior is unchanged. Synchronization creates **happens-before** relationships that publish earlier writes to later readers.

Common publication boundaries:

| Boundary | Ordering edge it creates | What that guarantees in practice |
|---|---|---|
| Exiting and entering the same `lock` | Exit is a release, entry is an acquire | Everything written inside the critical section is visible to the next thread that enters it |
| Any `Interlocked` operation | Full barrier around an atomic read-modify-write | The value is updated indivisibly and surrounding writes are not reordered across it |
| `Volatile.Write` then `Volatile.Read` of the same field | Release store paired with an acquire load | A reader that observes the new reference also observes everything written before the store |
| `Thread.Start` and `Thread.Join` | Start publishes the caller's prior writes to the new thread; join publishes the thread's writes to the joiner | Setup before `Start` and results after `Join` need no extra synchronization |
| Task completion and `await` | Completion happens-before the continuation | Values computed inside the task are safe to read after the await, on any thread |
| Add and take on a concurrent collection or `Channel<T>` | The producer's add happens-before the consumer's take of that item | The consumer sees a fully constructed item without its own lock |

```csharp
private Config _config = Config.Empty;

public Config Current => Volatile.Read(ref _config);

public void Replace(Config next)
{
    ArgumentNullException.ThrowIfNull(next);
    Volatile.Write(ref _config, next); // publish fully constructed immutable object
}
```

C# 14's `field` keyword expresses the same pattern without an explicit backing field, since `field` is an ordinary variable that can be passed by `ref`:

```csharp
public Config Current
{
    get => Volatile.Read(ref field);
    set => Volatile.Write(ref field, value ?? throw new ArgumentNullException(nameof(value)));
} = Config.Empty;
```

`volatile`/`Volatile` controls visibility and ordering for an individual location; it does **not** turn compound operations such as `x++` into atomic operations.

Test on the hardware you deploy to. x64 is strongly ordered and hides many missing-barrier bugs, while ARM64 (Graviton, Ampere, Apple silicon) reorders far more aggressively, so code that passes on an x64 developer machine can fail on an ARM64 server. Reason from the memory model, not from what happens to pass locally.

---

## Synchronization and Coordination

### S1. `System.Threading.Lock` and `lock`

[↑ Content](#content)

For new .NET 10 code, use a private dedicated `System.Threading.Lock` for synchronous mutual exclusion:

```csharp
private readonly Lock _gate = new();
private decimal _balance;

public void Credit(decimal amount)
{
    lock (_gate)
    {
        _balance += amount;
    }
}
```

With a `Lock` target, the C# compiler uses `EnterScope()` and guaranteed disposal. For other reference objects, `lock` uses `Monitor.Enter/Exit` with `try/finally`.

Rules:

- Lock a private dedicated object, never `this`, a `Type`, or an interned string.
- Keep the critical section short.
- Do not perform slow I/O or callbacks while holding a lock.
- Use one documented lock order when multiple locks are necessary.
- `lock` is reentrant for the owning thread.
- You cannot `await` inside a `lock` statement; ownership belongs to a thread, while continuation may resume elsewhere.

---

### S2. `Monitor`

[↑ Content](#content)

`Monitor` is the lower-level mechanism behind object-based `lock`. It also provides condition waiting:

```csharp
private readonly object _gate = new();
private readonly Queue<Job> _jobs = new();

public Job Take()
{
    lock (_gate)
    {
        while (_jobs.Count == 0)
            Monitor.Wait(_gate); // releases gate, waits, then reacquires it

        return _jobs.Dequeue();
    }
}

public void Add(Job job)
{
    lock (_gate)
    {
        _jobs.Enqueue(job);
        Monitor.Pulse(_gate);
    }
}
```

Always check the condition in a `while`, not `if`: another waiter can consume the state before this thread reacquires the monitor. Prefer `Channel<T>` or `BlockingCollection<T>` for most producer/consumer code.

---

### S3. `Interlocked`, `Volatile`, and `volatile`

[↑ Content](#content)

| Tool | Use | Limitation |
|---|---|---|
| `Interlocked` | Atomic increment, exchange, compare-and-swap | Best for one/few independent values |
| `Volatile.Read/Write` | Ordered visible read/write | No compound atomicity |
| `volatile` field | Language shorthand for supported field types | Easy to overestimate |

Compare-and-swap enables lock-free state transitions:

```csharp
private int _state = (int)State.Created;

public bool TryStart() =>
    Interlocked.CompareExchange(
        ref _state,
        (int)State.Running,
        (int)State.Created) == (int)State.Created;
```

Lock-free does not mean wait-free, simpler, or always faster. Under contention, retry loops can waste CPU and suffer ABA-like design problems.

---

### S4. Semaphores and Mutexes

[↑ Content](#content)

| Primitive | Scope | Purpose |
|---|---|---|
| `SemaphoreSlim` | One process | Limit concurrent access; supports `WaitAsync` |
| `Semaphore` | Kernel-backed | Cross-process capable, heavier |
| `Mutex` | Kernel-backed, one owner | Cross-process mutual exclusion |

```csharp
private readonly SemaphoreSlim _slots = new(initialCount: 8);

public async Task<Response> SendAsync(Request request, CancellationToken ct)
{
    await _slots.WaitAsync(ct);
    try
    {
        return await SendCoreAsync(request, ct);
    }
    finally
    {
        _slots.Release();
    }
}
```

`SemaphoreSlim(1, 1)` is commonly used as an async-compatible gate. It is not thread-affine, so ownership discipline is your responsibility: release exactly once only after successful acquisition.

---

### S5. `ReaderWriterLockSlim`

[↑ Content](#content)

Allows concurrent readers and exclusive writers. It can help when reads are frequent, long enough to amortize overhead, and writes are rare.

```csharp
private readonly ReaderWriterLockSlim _rw = new();
private readonly Dictionary<int, Item> _items = [];

public Item? Get(int id)
{
    _rw.EnterReadLock();
    try { return _items.GetValueOrDefault(id); }
    finally { _rw.ExitReadLock(); }
}
```

Do not assume it beats a simple lock. Short critical sections, frequent writes, or low contention often make `Lock` faster and easier. Measure representative workloads.

---

### S6. Events, Barrier, and CountdownEvent

[↑ Content](#content)

| Primitive | Meaning |
|---|---|
| `ManualResetEventSlim` | Gate stays open until reset |
| `AutoResetEvent` | Releases one waiter per signal, then resets |
| `CountdownEvent` | Opens after N signals |
| `Barrier` | Participants meet at repeated phases |

These are mainly synchronous thread-coordination tools. Blocking a ThreadPool worker while waiting reduces scalability. In task-based code, prefer task completion, `WhenAll`, channels, or async-friendly primitives.

---

### S7. Spin Primitives

[↑ Content](#content)

`SpinWait`, `SpinLock`, and `ManualResetEventSlim` may spin briefly before yielding/blocking. Spinning can avoid a kernel transition when waits are extremely short, but it burns CPU and degrades badly under oversubscription.

Use only after measurement. Never spin around I/O, an unbounded condition, or on a single-core assumption. General application code should prefer `Lock`, `Interlocked`, or task-based coordination.

---

### S8. Primitive Selection

[↑ Content](#content)

| Need | Usually choose |
|---|---|
| Exclusive synchronous access | `lock` over private `Lock` |
| Atomic counter/reference swap | `Interlocked` |
| Publish immutable snapshot | `Volatile.Read/Write` or `Interlocked.Exchange` |
| Async mutual exclusion | `SemaphoreSlim(1, 1)` |
| Limit concurrency to N | `SemaphoreSlim(N)` or bounded channel |
| Producer/consumer stream | `Channel<T>` |
| Shared keyed state | `ConcurrentDictionary<TKey,TValue>` |
| Cross-process exclusivity | Named `Mutex` |
| Wait for many tasks | `Task.WhenAll` |
| Repeated phase rendezvous | `Barrier` |

Choose based on semantics first, benchmark second. A “faster” primitive with the wrong ownership or fairness behavior is incorrect.

---

## Tasks, Async, and Parallelism

### T1. `Task` and `Task.Run`

[↑ Content](#content)

`Task` represents completion and carries result, exception, and cancellation state. `Task.Run` queues a delegate to the ThreadPool.

```csharp
public Task<Report> BuildAsync(Input input, CancellationToken ct) =>
    Task.Run(() => BuildReport(input, ct), ct);
```

Use `Task.Run` for CPU-bound work when offloading is part of the API's intent (especially UI code). ASP.NET Core already runs request code on ThreadPool threads; wrapping CPU work in `Task.Run` usually just moves it to another worker and does not create capacity.

For long-running blocking work, consider a dedicated service/thread or redesign around async I/O rather than occupying ThreadPool workers.

---

### T2. `async` and `await`

[↑ Content](#content)

An async method runs synchronously until an incomplete await. It then registers a continuation and returns a task. Awaiting does not block the current thread.

```csharp
public async Task<string> LoadAsync(Uri uri, CancellationToken ct)
{
    using var response = await _http.GetAsync(uri, ct);
    response.EnsureSuccessStatusCode();
    return await response.Content.ReadAsStringAsync(ct);
}
```

Important:

- `async` does not imply a new thread.
- Return types: `Task` / `Task<T>` for almost all methods; `ValueTask` / `ValueTask<T>` on measured hot paths; `async void` only for event handlers.
- Avoid `async void` except event handlers; callers cannot await or reliably observe exceptions.
- Return the task directly when no post-await logic or exception scope is required (“eliding `async`”).
- “Async all the way” avoids blocking and context deadlocks.

---

### T3. `Task.WhenAll`, `Task.WhenAny`, and `Task.WhenEach`

[↑ Content](#content)

Start independent operations before awaiting them:

```csharp
Task<User> userTask = LoadUserAsync(id, ct);
Task<Order[]> ordersTask = LoadOrdersAsync(id, ct);

await Task.WhenAll(userTask, ordersTask);
return new Dashboard(await userTask, await ordersTask);
```

| API | Completes when | Result | Typical use |
|---|---|---|---|
| `WhenAll` | Every input finishes | One task; faults if any input faults | You need every result (or every side effect) before continuing |
| `WhenAny` | The first input finishes | That inner `Task` — you must still `await` it | Timeout races, first-successful replica, cancellation of siblings |
| `WhenEach` (.NET 9+) | Yields each input as *that* input finishes | `IAsyncEnumerable<Task>` / `IAsyncEnumerable<Task<T>>` | Process completions in finish order without a `WhenAny` loop |

`WhenAll` provides concurrency, not automatically parallel threads. `WhenAny` does not cancel the losers; remaining work keeps running until you cancel it. `WhenEach` replaces the old “`While` + `WhenAny` + remove from list” pattern:

```csharp
List<Task<int>> downloads = urls.Select(url => DownloadSizeAsync(url, ct)).ToList();

int total = 0;
await foreach (Task<int> finished in Task.WhenEach(downloads))
    total += await finished;
```

Do not launch an unbounded task per item. `WhenAll` over 100,000 network calls can exhaust sockets, memory, rate limits, or downstream capacity.

---

### T4. Cooperative Cancellation

[↑ Content](#content)

Cancellation is a request, not forced termination:

```csharp
public async Task ProcessAsync(CancellationToken ct)
{
    foreach (var item in _items)
    {
        ct.ThrowIfCancellationRequested();
        await ProcessItemAsync(item, ct);
    }
}
```

Guidelines:

- Accept `CancellationToken` as the last parameter.
- Pass it through to every operation that supports it.
- Check it periodically in CPU loops.
- Throw `OperationCanceledException` with the matching token.
- After an irreversible commit, either finish consistently or define compensation; cancellation must not corrupt invariants.
- Dispose linked/token sources that you create.

Timeouts are cancellation with a deadline. Prefer a linked `CancellationTokenSource` so the underlying operation is actually told to stop, not only abandoned:

```csharp
using CancellationTokenSource timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
timeoutCts.CancelAfter(TimeSpan.FromSeconds(5));

try
{
    return await _http.GetStringAsync(uri, timeoutCts.Token);
}
catch (OperationCanceledException) when (!ct.IsCancellationRequested)
{
    throw new TimeoutException($"GET {uri} exceeded 5 seconds.");
}
```

`Task.WaitAsync(TimeSpan)` (.NET 6+) bounds how long *you* wait. It does not cancel the original task unless you also pass a token into that task.

---

### T5. Task Exceptions

[↑ Content](#content)

Await rethrows the operation's exception at the await point. Tasks retain all exceptions; blocking APIs and some aggregate operations expose `AggregateException`.

```csharp
try
{
    await Task.WhenAll(tasks);
}
catch
{
    foreach (Task task in tasks.Where(t => t.IsFaulted))
        Log(task.Exception!);
    throw;
}
```

Always observe fire-and-forget failures through a supervised background queue/service. Assigning a task to `_` does not make its errors safe.

---

### T6. `ValueTask`

[↑ Content](#content)

`ValueTask<T>` can avoid allocating a `Task<T>` when operations often complete synchronously. It is an optimization for measured hot paths, not a default return type.

Rules:

- Usually await it exactly once.
- Do not casually store it, await it multiple times, or combine it repeatedly.
- Convert with `.AsTask()` when task semantics are required (possibly allocating).
- Public APIs should prefer `Task<T>` unless profiling proves value.

---

### T7. Parallel Loops and PLINQ

[↑ Content](#content)

Use data parallelism for independent, sufficiently expensive CPU work:

```csharp
ParallelOptions options = new()
{
    MaxDegreeOfParallelism = Environment.ProcessorCount,
    CancellationToken = ct
};

Parallel.ForEach(images, options, image => Transform(image));
```

`Parallel.ForEachAsync` supports async delegates and bounded degree:

```csharp
await Parallel.ForEachAsync(
    urls,
    new ParallelOptions { MaxDegreeOfParallelism = 16, CancellationToken = ct },
    async (url, token) => await DownloadAsync(url, token));
```

PLINQ (`source.AsParallel()`) partitions a query. Ordering, merge cost, delegate cost, and shared writes can erase gains. Use `.AsOrdered()` only when required because ordering adds overhead.

---

### T8. Bounded Concurrency

[↑ Content](#content)

Bound concurrency to protect your process and dependencies:

```csharp
public static async Task<TResult[]> SelectBoundedAsync<T, TResult>(
    IEnumerable<T> source,
    int degree,
    Func<T, CancellationToken, Task<TResult>> selector,
    CancellationToken ct)
{
    using var gate = new SemaphoreSlim(degree);

    var tasks = source.Select(async item =>
    {
        await gate.WaitAsync(ct);
        try { return await selector(item, ct); }
        finally { gate.Release(); }
    });

    return await Task.WhenAll(tasks);
}
```

For an unbounded or streaming input, a bounded `Channel<T>` is better because it also supplies backpressure instead of creating all task objects up front.

---

### T9. `TaskCompletionSource`

[↑ Content](#content)

Bridges callback/event completion into a task:

```csharp
var tcs = new TaskCompletionSource<Message>(
    TaskCreationOptions.RunContinuationsAsynchronously);

void OnMessage(Message message) => tcs.TrySetResult(message);
```

Use `TrySet...` when completion can race. `RunContinuationsAsynchronously` prevents consumer continuations from executing inline inside the producer's lock/callback, reducing reentrancy and latency surprises.

---

### T10. `SynchronizationContext` and `ConfigureAwait`

[↑ Content](#content)

UI frameworks use a `SynchronizationContext` to marshal continuations back to the UI thread. Classic ASP.NET also had a context; ASP.NET Core normally does not.

```csharp
// Library code that does not need the caller's context:
var bytes = await stream.ReadAsync(buffer, ct).ConfigureAwait(false);
```

Blocking the UI thread with `.Result` while the async continuation needs that same thread creates a deadlock. Await instead.

| Call | Continuation runs | Use when |
|---|---|---|
| `await t` / `ConfigureAwait(true)` | Captured `SynchronizationContext` or `TaskScheduler`, if any | App/UI code that must touch thread-affine objects after the await |
| `ConfigureAwait(false)` | Wherever the completer scheduled it (usually the ThreadPool) | Reusable library code that does not need the caller's context |

Use `ConfigureAwait(false)` consistently in reusable libraries when continuation affinity is unnecessary. ASP.NET Core has no request `SynchronizationContext`, so the classic deadlock pattern is rare there — blocking still starves the ThreadPool. `ConfigureAwait` does **not** control `ExecutionContext` / `AsyncLocal<T>`; those still flow (see [T13](#t13-executioncontext-and-asynclocalt)).

It is not a general performance incantation and does not make unsafe code thread-safe.

---

### T11. `IAsyncEnumerable<T>`

[↑ Content](#content)

`IEnumerable<T>` pulls the next item synchronously (`MoveNext`). `IAsyncEnumerable<T>` pulls it asynchronously (`MoveNextAsync`), so the producer can `await` between items. The consumer uses `await foreach`. That pairing is natural **backpressure**: the producer does not generate the next item until the consumer asks for it.

```csharp
async IAsyncEnumerable<string> ReadLinesAsync(
    Stream stream,
    [EnumeratorCancellation] CancellationToken ct = default)
{
    using StreamReader reader = new(stream);
    string? line;
    while ((line = await reader.ReadLineAsync(ct)) is not null)
        yield return line;
}

await foreach (string line in ReadLinesAsync(stream, ct))
    await HandleAsync(line, ct);
```

`[EnumeratorCancellation]` forwards the token from `WithCancellation` / `await foreach` into the iterator. Without it, cancelling the loop may not stop the producer until the next `yield`.

Do not mix this up with `Task<IEnumerable<T>>`, which buffers the whole sequence before the caller sees the first item.

---

### T12. `IAsyncDisposable`

[↑ Content](#content)

Use `IAsyncDisposable` when cleanup itself needs to `await` — flushing a socket, completing a channel writer, or disposing an async stream. `await using` calls `DisposeAsync` and waits for it.

```csharp
public sealed class AuditSink : IAsyncDisposable
{
    private readonly Channel<Event> _channel = Channel.CreateBounded<Event>(256);
    private readonly Task _pump;

    public AuditSink() => _pump = PumpAsync();

    public async ValueTask DisposeAsync()
    {
        _channel.Writer.TryComplete();
        await _pump.ConfigureAwait(false);
    }
}

await using AuditSink sink = new();
await sink.WriteAsync(evt, ct);
```

`DisposeAsync` returns `ValueTask` so already-complete disposal need not allocate. Do not implement async cleanup by blocking inside synchronous `Dispose()` (`DisposeAsync().GetAwaiter().GetResult()`); that reintroduces sync-over-async. Prefer `await using` at every call site that can be async.

---

### T13. ExecutionContext and `AsyncLocal<T>`

[↑ Content](#content)

`ExecutionContext` is the logical call context that flows across `await` and ThreadPool work: `AsyncLocal<T>`, security information, and related ambient state. It is **not** the same as `SynchronizationContext`. `ConfigureAwait(false)` suppresses context *marshaling*; ExecutionContext still flows unless you suppress it.

```csharp
AsyncLocal<string> tenant = new();
tenant.Value = "acme";

await Task.Delay(1, ct);
Console.WriteLine(tenant.Value); // "acme" — flowed across the await

using (ExecutionContext.SuppressFlow())
{
    _ = Task.Run(() => Console.WriteLine(tenant.Value ?? "(none)"));
}
```

`AsyncLocal<T>` is useful for ambient request/activity IDs. It is a liability when it captures `HttpContext`, a scoped `DbContext`, or a large object graph onto a long-lived background task — the request ends, the objects are disposed, and the background work still sees them. Clear or avoid ambient state at fire-and-forget boundaries.

---

## Collections, Channels, and Safer Designs

[↑ Content](#content)

### Concurrent collections

| Type | Best fit |
|---|---|
| `ConcurrentDictionary<TKey,TValue>` | Shared key/value state and atomic per-key operations |
| `ConcurrentQueue<T>` | Multi-producer/multi-consumer FIFO |
| `ConcurrentStack<T>` | Concurrent LIFO |
| `ConcurrentBag<T>` | Unordered, thread-locality-friendly accumulation |
| `BlockingCollection<T>` | Blocking producer/consumer over a concurrent collection |

Compound logic still needs care:

```csharp
// Factory may run more than once; only one produced value is stored.
var value = cache.GetOrAdd(key, static k => ExpensiveCreate(k));
```

If creation must happen once, store `Lazy<T>` or `Task<T>` as the dictionary value and decide how failures/eviction work.

### Channels and backpressure

```csharp
Channel<Job> channel = Channel.CreateBounded<Job>(
    new BoundedChannelOptions(100)
    {
        FullMode = BoundedChannelFullMode.Wait,
        SingleReader = true
    });

await channel.Writer.WriteAsync(job, ct);

await foreach (Job next in channel.Reader.ReadAllAsync(ct))
    await HandleAsync(next, ct);
```

A bounded channel makes overload behavior explicit: producers wait or a configured item is dropped; callers using `TryWrite` can also fail or retry when it returns `false`. This is often safer than a shared queue plus manual signaling.

### Immutability, partitioning, and ownership

- Immutable records can be shared without locks.
- Per-worker accumulators avoid a lock on every item; merge once at the end.
- Actor/message-loop designs serialize access through one owner.
- `ThreadLocal<T>` and `Parallel.For` local state reduce contention, but values require disposal/merging.
- `AsyncLocal<T>` flows logical call context across awaits; it is not ordinary thread-local storage and can create hidden coupling.

---

## Junior Interview Questions

### J1. What is a race condition?

[↑ Content](#content)

A race condition occurs when a result depends on nondeterministic interleaving of concurrent operations. Prevent it by removing shared mutation or by synchronizing the entire invariant—not merely individual reads and writes.

### J2. What is the difference between a thread and a task?

[↑ Content](#content)

A thread is an OS-scheduled execution resource. A task is a composable representation of completion that may use a thread, asynchronous I/O, or no scheduling at all.

### J3. Does `async` create a new thread?

[↑ Content](#content)

No. An async method runs on its current thread until an incomplete await, registers a continuation, and returns. `Task.Run` explicitly queues CPU work to the ThreadPool. Full walkthrough: [AJ1](#aj1-what-is-async-and-await-in-c), [AJ3](#aj3-what-happens-when-an-async-method-is-called), [AJ5](#aj5-what-is-the-difference-between-taskrun-and-asyncawait).

### J4. What does `lock` guarantee?

[↑ Content](#content)

Only one thread at a time can execute a critical section for the same lock instance. Enter/exit also establishes memory-ordering guarantees so protected writes become visible.

### J5. Why is `counter++` not thread-safe?

[↑ Content](#content)

It consists of a read, increment, and write. Interleaving loses updates. Use `Interlocked.Increment` for a standalone counter or a lock when the counter belongs to a larger invariant.

### J6. How do you stop work safely?

[↑ Content](#content)

Use cooperative `CancellationToken`, propagate it, and leave state consistent. Do not kill threads arbitrarily.

### J7. `Thread.Sleep` vs `Task.Delay`?

[↑ Content](#content)

`Thread.Sleep` blocks the current thread. `Task.Delay` returns a task completed by a timer and frees the thread while waiting. Use `Task.Delay` in async flows. Example and failure modes: [AJ6](#aj6-what-is-the-difference-between-await-taskdelay-and-threadsleep).

### J8. Foreground vs background thread?

[↑ Content](#content)

Foreground threads keep the process alive; background threads do not. ThreadPool threads are background threads. Graceful shutdown still requires cancellation and awaiting workers—do not rely on process termination.

---

## Mid-Level Interview Questions

### M1. Why can `.Result` or `.Wait()` deadlock?

[↑ Content](#content)

The caller blocks a context thread; the awaited continuation is queued back to that same context, which cannot run. Even without a context, blocking wastes ThreadPool threads and can cause starvation. Use `await`. Worked example: [AJ7](#aj7-why-should-you-avoid-result-and-wait-on-async-tasks), [AM5](#am5-how-do-you-avoid-deadlocks-in-async-code).

### M2. How do you implement an async lock?

[↑ Content](#content)

Use `SemaphoreSlim(1, 1)` with `WaitAsync` and `Release` in `finally`, or a well-tested wrapper. Do not `await` while holding `lock`/`Monitor`.

### M3. When is `ConcurrentDictionary` insufficient?

[↑ Content](#content)

Its individual methods are thread-safe, but a sequence such as “check A, update B, remove C” is not one transaction. Use atomic dictionary APIs, store an immutable aggregate and swap it, or lock the multi-step invariant.

### M4. How do `WhenAll` exceptions work?

[↑ Content](#content)

The returned task records all child failures. Await throws one exception, while the task's `Exception` contains the aggregate. Inspect children/aggregate when every failure matters, and never abandon unobserved tasks.

### M5. How do you limit outgoing request concurrency?

[↑ Content](#content)

Use `SemaphoreSlim`, `Parallel.ForEachAsync`, or a bounded channel. Choose a limit from downstream capacity and latency measurements, propagate cancellation, and define retry/backpressure policy.

### M6. `lock` vs `SemaphoreSlim`?

[↑ Content](#content)

Use `lock` for short synchronous exclusive sections; it is simpler and ownership is thread-bound. Use `SemaphoreSlim` for async waiting or N permits. A semaphore does not enforce owner release.

### M7. When would you use `Parallel.ForEachAsync`?

[↑ Content](#content)

For many independent items when explicit maximum concurrency is useful. For pure CPU work, keep degree near available cores. For async I/O, tune against external capacity—not core count.

### M8. What is thread safety?

[↑ Content](#content)

Code is thread-safe when it preserves its documented invariants under all permitted concurrent calls. “Uses a concurrent collection” or “each field is atomic” is not sufficient proof.

---

## Senior Interview Questions

### SR1. Explain safe publication.

[↑ Content](#content)

Safe publication ensures another thread cannot observe a partially initialized or stale object. Publish an immutable fully constructed object through a lock, volatile write/read pair, interlocked exchange, task completion, or a thread-safe collection.

### SR2. Is double-checked locking safe?

[↑ Content](#content)

It can be correct with proper volatile publication, but `Lazy<T>` or static initialization is clearer and harder to break:

```csharp
private static readonly Lazy<Service> InstanceFactory =
    new(() => new Service(), LazyThreadSafetyMode.ExecutionAndPublication);

public static Service Instance => InstanceFactory.Value;
```

Static type initialization is thread-safe. Prefer it when initialization needs no runtime parameter.

### SR3. Deadlock, livelock, and starvation?

[↑ Content](#content)

| Failure | Meaning |
|---|---|
| **Deadlock** | Participants wait forever in a dependency cycle |
| **Livelock** | Participants run but repeatedly yield/retry without progress |
| **Starvation** | One operation is continually denied resources |

Prevent lock deadlocks with fixed ordering, small lock scope, no external callbacks under locks, and timeouts/cancellation where semantics allow.

### SR4. What causes ThreadPool starvation?

[↑ Content](#content)

Many pool workers block on sync I/O, locks, task waits, or long work; queued work and continuations cannot run until the pool injects threads. Symptoms include rising queue length and latency while CPU may remain below saturation.

Fix the blocking source, use async I/O, bound concurrency, and move truly dedicated blocking loops away from the pool. Raising minimum threads can mask symptoms but does not repair the design.

### SR5. What is false sharing?

[↑ Content](#content)

Independent hot fields on the same cache line are written by different cores, causing cache-line invalidation traffic. It appears as poor scaling without logical contention. Diagnose with measurement; mitigate by partitioning data or careful padding/layout only in proven hot paths.

### SR6. Lock-free vs wait-free?

[↑ Content](#content)

- **Lock-free:** system-wide progress is guaranteed; an individual operation may starve.
- **Wait-free:** every operation completes within bounded steps.
- **Obstruction-free:** progress occurs when running in isolation.

Most application code should prefer simple locks. Lock-free algorithms are difficult to prove, can allocate/retry heavily, and may need ABA and reclamation strategies.

### SR7. How do you design a high-throughput pipeline?

[↑ Content](#content)

Use bounded stages connected by channels, explicit ownership, controlled parallelism per stage, cancellation, completion propagation, and metrics. Backpressure prevents fast producers from exhausting memory when consumers slow down.

```text
Ingress → bounded channel → parse workers
        → bounded channel → business workers
        → bounded channel → batched output
```

### SR8. How do ASP.NET Core concurrency rules differ from UI apps?

[↑ Content](#content)

ASP.NET Core normally has no request `SynchronizationContext`, so continuations need not return to the original thread. Request-scoped services may still be non-thread-safe: starting parallel operations that share one `DbContext`, stream, or mutable scope is unsafe. UI apps require thread affinity for controls.

### SR9. How do you test concurrent code?

[↑ Content](#content)

Separate pure state transitions from scheduling, inject clocks/queues, use barriers or task completions to force interleavings, apply timeouts, repeat stress tests, and assert invariants rather than timing. `Thread.Sleep`-based tests are slow and nondeterministic.

### SR10. How do you choose between optimistic and pessimistic coordination?

[↑ Content](#content)

Use optimistic compare-and-swap/versioning when conflicts are rare and retries are cheap. Use exclusive locking when conflicts are common or transitions span complex invariants. Measure retry rate, contention, tail latency, and fairness—not only average throughput.

---

## Async / Await Interview Questions

[↑ Content](#content)

These thirty questions match the common async/await interview ladder. Answer in the same order as the rest of this guide: **define → mechanism → failure mode → short example**. Cross-references point at the conceptual sections when the interviewer wants more depth.

### Async Junior (0-2 Years)

#### AJ1. What is async and await in C#?

[↑ Content](#content)

`async` marks a method the compiler may rewrite as a state machine. `await` yields control when the awaited operation is incomplete, then resumes through a continuation when it completes. Neither keyword creates a thread.

```csharp
public async Task<string> GetTitleAsync(int id, CancellationToken ct)
{
    using HttpResponseMessage response = await _http.GetAsync($"/items/{id}", ct);
    response.EnsureSuccessStatusCode();
    return await response.Content.ReadAsStringAsync(ct);
}
```

The method runs **synchronously** until the first incomplete `await`. If every awaited operation is already complete (cache hit, `Task.FromResult`), it can finish without ever yielding. See [T2](#t2-async-and-await).

---

#### AJ2. What is the difference between synchronous and asynchronous code?

[↑ Content](#content)

**Synchronous** code occupies a thread for the entire duration of the operation. **Asynchronous** code starts the operation and returns control; completion is observed later. For I/O, no thread needs to sit in a wait state while the device or remote peer works.

```csharp
// Synchronous: this thread is blocked for the whole round-trip.
string blocked = _http.GetStringAsync(uri).GetAwaiter().GetResult();

// Asynchronous: this thread is released during the round-trip.
string streamed = await _http.GetStringAsync(uri, ct);
```

Async is a *control-flow* property. It is not the same as parallelism (simultaneous execution on multiple cores). See [C1](#c1-concurrency-parallelism-and-asynchrony).

---

#### AJ3. What happens when an async method is called?

[↑ Content](#content)

1. The method starts on the **caller's thread**.
2. It runs until the first `await` of an incomplete awaitable.
3. The compiler-generated state machine captures locals, registers a continuation, and **returns an incomplete `Task`** to the caller.
4. When the awaitable completes, the continuation is scheduled (ThreadPool, or a captured `SynchronizationContext`).
5. The method resumes after the `await` and eventually completes the task it returned.

```csharp
public async Task DemoAsync()
{
    Console.WriteLine("A");          // runs before DemoAsync returns to its caller
    await Task.Delay(100);           // yields; the returned Task is still incomplete
    Console.WriteLine("B");          // continuation
}

Task t = DemoAsync(); // "A" has already printed; t is not complete
await t;              // waits until "B" has run
```

Calling an async method does **not** queue it. The `Task` is hot: work has already started.

---

#### AJ4. What is `Task`, `Task<T>`, and `ValueTask`?

[↑ Content](#content)

A `Task` is a promise of completion: status, exception, and cancellation. `Task<T>` adds a result. `ValueTask` / `ValueTask<T>` is a struct that can hold an already-available result *or* wrap a `Task`, avoiding a heap allocation on hot paths that often complete synchronously.

```csharp
public Task SaveAsync(Order order, CancellationToken ct) =>
    _db.SaveChangesAsync(ct);

public Task<Order?> GetAsync(int id, CancellationToken ct) =>
    _db.Orders.FindAsync([id], ct).AsTask();

public ValueTask<int> GetCountAsync()
{
    if (_cache.TryGetValue("count", out int n))
        return ValueTask.FromResult(n); // no Task allocation

    return new ValueTask<int>(LoadCountAsync());
}
```

Default public APIs to `Task` / `Task<T>`. Reach for `ValueTask` only after measurement. See [T1](#t1-task-and-taskrun) and [T6](#t6-valuetask).

---

#### AJ5. What is the difference between `Task.Run()` and async/await?

[↑ Content](#content)

`async`/`await` **compose** asynchronous operations. They do not schedule CPU work. `Task.Run` **queues a delegate** onto the ThreadPool so CPU-bound work does not occupy the calling thread (typically a UI thread).

```csharp
// I/O-bound: just await. Task.Run would occupy a worker for no gain.
string json = await _http.GetStringAsync(uri, ct);

// CPU-bound, UI app: offload so the UI thread stays responsive.
int hash = await Task.Run(() => ComputeHash(json), ct);
```

Wrapping an already-async I/O call in `Task.Run` does not make it “more async.” In ASP.NET Core the request is already on a pool thread, so `Task.Run` usually just moves work to another worker. See [C3](#c3-cpu-bound-vs-io-bound).

---

#### AJ6. What is the difference between `await Task.Delay()` and `Thread.Sleep()`?

[↑ Content](#content)

`Thread.Sleep` **blocks** the current thread; the OS parks it and it cannot run other work. `await Task.Delay` returns a task completed by a timer, **frees the thread**, and is cancellable.

```csharp
Thread.Sleep(1000);             // this worker is occupied for 1s
await Task.Delay(1000, ct);     // this worker is free for 1s; ct can abort the wait
```

In async code, `Sleep` is a ThreadPool-starvation bug waiting to happen. The same distinction applies to any blocking wait versus an awaitable delay or I/O.

---

#### AJ7. Why should you avoid `.Result` and `.Wait()` on async tasks?

[↑ Content](#content)

They turn an asynchronous operation back into a **blocking** one.

- On a UI or classic ASP.NET `SynchronizationContext`, the continuation needs the blocked thread → **deadlock**.
- Without a context, a ThreadPool worker is occupied until completion → **starvation** under load.
- `.Result` / `.Wait()` wrap failures in `AggregateException`; `await` unwraps the inner exception.
- `.GetAwaiter().GetResult()` avoids the aggregate wrap but still blocks.

```csharp
// Deadlock on a captured UI / classic ASP.NET context:
string s = LoadAsync().Result;

// Correct:
string s = await LoadAsync();
```

“Async all the way” is the rule. The blocking APIs exist for entry points that cannot be async (a few legacy sync surfaces), not for ordinary application code.

---

#### AJ8. How does async/await avoid blocking threads?

[↑ Content](#content)

For I/O, the wait lives in the OS (IOCP on Windows, epoll/kqueue elsewhere). No managed thread sits in `WaitForSingleObject` on that socket. When the I/O completes, a callback queues the state machine's continuation onto the ThreadPool (or a captured context).

For an incomplete `Task`, `await` registers that continuation and **returns the current thread to the caller**. The rest of the method is not on any stack until resume.

```csharp
public async Task CopyAsync(Stream src, Stream dest, CancellationToken ct)
{
    byte[] buffer = ArrayPool<byte>.Shared.Rent(16 * 1024);
    try
    {
        int read;
        while ((read = await src.ReadAsync(buffer, ct)) > 0)
            await dest.WriteAsync(buffer.AsMemory(0, read), ct);
    }
    finally
    {
        ArrayPool<byte>.Shared.Return(buffer);
    }
}
```

CPU-bound work still needs a thread. `await` does not make a hash or image resize cheaper; it only avoids occupying a thread *while waiting*.

---

#### AJ9. What is the difference between `async void`, `async Task`, and `async Task<T>`?

[↑ Content](#content)

| Signature | Caller can await? | Exceptions | Use |
|---|---|---|---|
| `async Task` | Yes | Stored on the task; thrown at `await` | Most methods |
| `async Task<T>` | Yes | Same, plus a result | Most methods that return a value |
| `async void` | No | Raised on the captured `SynchronizationContext` (often a crash) | Event handlers only |

```csharp
public async Task SaveAsync(CancellationToken ct) =>
    await _db.SaveChangesAsync(ct);

public async Task<int> CountAsync(CancellationToken ct) =>
    await _db.Orders.CountAsync(ct);

private async void OnSaveClicked(object? sender, RoutedEventArgs e)
{
    try
    {
        await SaveAsync(CancellationToken.None);
    }
    catch (Exception ex)
    {
        ShowError(ex); // must be caught here; the caller cannot await this handler
    }
}
```

`async void` also breaks `try`/`finally` around the *call site* and makes tests race. Never use it on interfaces, lambdas passed as `Action`, or ASP.NET actions.

---

#### AJ10. What happens if you don't await a Task?

[↑ Content](#content)

The operation is already running (hot task). Not awaiting it means you **do not wait for completion** and **do not observe exceptions**. In ASP.NET Core the request may finish, dispose scoped services, and return a response while that work is still in flight.

```csharp
_ = SendEmailAsync(user, ct);     // fire-and-forget: failures vanish; scope may die first
await SendEmailAsync(user, ct);   // completion and exceptions are observed
```

If the caller truly cannot await, hand the work to a hosted background queue and observe failures there. Assigning to `_` is not a strategy. See [T5](#t5-task-exceptions).

---

### Async Mid (2-5 Years)

#### AM1. What is the difference between `Task.WhenAll`, `Task.WhenAny`, and `Task.WhenEach`?

[↑ Content](#content)

Start the tasks first, then choose how to wait. See [T3](#t3-taskwhenall-taskwhenany-and-taskwheneach).

```csharp
Task<User> user = LoadUserAsync(id, ct);
Task<Order[]> orders = LoadOrdersAsync(id, ct);
await Task.WhenAll(user, orders);                 // need both

Task<string> winner = await Task.WhenAny(east, west);
string body = await winner;                       // still await the inner task

int total = 0;
await foreach (Task<int> done in Task.WhenEach(downloads))
    total += await done;                          // process in completion order (.NET 9+)
```

- `WhenAll` faults if any child faults; inspect `Exception` / children when every failure matters.
- `WhenAny` does **not** cancel the losers. Cancel them yourself if their work is now wasted.
- `WhenEach` yields each task as it finishes, replacing a `WhenAny` + remove-from-list loop.

Never `WhenAll` an unbounded set of I/O calls.

---

#### AM2. How do you handle exceptions in async code?

[↑ Content](#content)

`await` throws the inner exception at the await site. Catch there, the same as synchronous code. Tasks remember **all** exceptions; `WhenAll` still throws only one of them from `await`.

```csharp
try
{
    await ChargeAsync(order, ct);
}
catch (OperationCanceledException) when (ct.IsCancellationRequested)
{
    throw;
}
catch (HttpRequestException ex)
{
    _logger.LogWarning(ex, "Payment gateway unavailable for {OrderId}", order.Id);
    throw;
}

try
{
    await Task.WhenAll(a, b, c);
}
catch (Exception)
{
    foreach (Task child in new[] { a, b, c }.Where(t => t.IsFaulted))
        _logger.LogError(child.Exception, "Parallel load failed");
    throw;
}
```

`async void` exceptions cannot be caught by the caller. Unawaited tasks surface as unobserved-task events, or not at all. Filter cancellation separately from faults so a shutdown is not logged as an error.

---

#### AM3. How do you implement a timeout for an async operation?

[↑ Content](#content)

A timeout is cancellation with a deadline. Link the caller's token with a timed source so the **underlying operation is told to stop**, not merely abandoned.

```csharp
public async Task<string> GetWithTimeoutAsync(Uri uri, TimeSpan timeout, CancellationToken ct)
{
    using CancellationTokenSource timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(ct);
    timeoutCts.CancelAfter(timeout);

    try
    {
        return await _http.GetStringAsync(uri, timeoutCts.Token);
    }
    catch (OperationCanceledException) when (!ct.IsCancellationRequested)
    {
        throw new TimeoutException($"GET {uri} exceeded {timeout}.");
    }
}
```

`await operation.WaitAsync(timeout, ct)` (.NET 6+) bounds the *wait*. If you do not also cancel `operation`, it keeps running in the background — a leak under load. Prefer passing the timed token into the API that does the work.

---

#### AM4. What is `CancellationToken` and how do you use it in async methods?

[↑ Content](#content)

It is a **cooperative** signal: a request to stop, not a forced abort. Accept it as the last parameter, pass it to every cancellable API, and poll it in CPU loops.

```csharp
public async Task ProcessAsync(IReadOnlyList<Item> items, CancellationToken ct)
{
    foreach (Item item in items)
    {
        ct.ThrowIfCancellationRequested();
        await ProcessItemAsync(item, ct);
    }
}

// Combine request abort with a deadline:
using CancellationTokenSource linked = CancellationTokenSource.CreateLinkedTokenSource(ct);
linked.CancelAfter(TimeSpan.FromSeconds(30));
await ProcessAsync(items, linked.Token);
```

Throw `OperationCanceledException` (via `ThrowIfCancellationRequested`) with the matching token so callers can tell cancel from failure. After an irreversible commit, finish consistently or compensate — do not leave half-written state. Dispose token sources you create. See [T4](#t4-cooperative-cancellation).

---

#### AM5. How do you avoid deadlocks in async code?

[↑ Content](#content)

The classic deadlock is **sync-over-async on a captured context**: the caller blocks a thread the continuation needs.

```csharp
// UI thread calls:
string html = GetHtmlAsync().Result;
// GetHtmlAsync awaited something and queued its continuation back to the UI thread,
// which is stuck on .Result.
```

Rules that actually prevent it:

1. Async all the way — `await`, never `.Result` / `.Wait()` / `.GetAwaiter().GetResult()` on those paths.
2. `ConfigureAwait(false)` in reusable libraries so continuations do not demand the caller's context.
3. Never `await` inside `lock` / `Monitor`; use `SemaphoreSlim.WaitAsync` for async mutual exclusion.
4. Do not block ThreadPool workers on other tasks; that is starvation, which presents like a deadlock under load.

ASP.NET Core has no request `SynchronizationContext`, so the *context* deadlock is uncommon — blocking is still wrong.

---

#### AM6. Explain `IAsyncEnumerable<T>` and how it differs from `IEnumerable<T>`.

[↑ Content](#content)

`IEnumerable<T>` produces the next element synchronously. `IAsyncEnumerable<T>` produces it asynchronously, so the iterator can `await` I/O between `yield return`s. Consume with `await foreach`.

```csharp
async IAsyncEnumerable<LogLine> TailAsync(
    Stream stream,
    [EnumeratorCancellation] CancellationToken ct = default)
{
    using StreamReader reader = new(stream);
    while (await reader.ReadLineAsync(ct) is { } line)
        yield return new LogLine(line);
}

await foreach (LogLine line in TailAsync(stream, ct))
    await IndexAsync(line, ct);
```

`Task<List<T>>` / `Task<IEnumerable<T>>` buffers everything before the caller sees item one. `IAsyncEnumerable<T>` streams and applies **backpressure**: the producer pauses until the consumer asks for the next item. See [T11](#t11-iasyncenumerablet).

---

#### AM7. What is the difference between CPU-bound and I/O-bound operations in async programming?

[↑ Content](#content)

| | I/O-bound | CPU-bound |
|---|---|---|
| Time is spent | Waiting on a device or peer | Executing instructions |
| Async helps by | Releasing the thread during the wait | Not at all, by itself |
| Preferred API | Native `*Async` + `await` | Run in place; `Task.Run` / `Parallel` when offload or cores are the point |
| Wrong move | `Task.Run(() => File.ReadAllText(path))` | `await` expecting the CPU work to get cheaper |

```csharp
var bytes = await blob.DownloadAsync(ct);                 // I/O
var digest = SHA256.HashData(bytes.Span);                 // CPU, cheap enough in-request
var tiles = await Task.Run(() => SharpenAll(images), ct); // CPU, offloaded (UI / dedicated worker)
```

Misclassifying I/O as CPU (wrapping sync I/O in `Task.Run`) parks one worker per request. See [C3](#c3-cpu-bound-vs-io-bound).

---

#### AM8. How would you optimize performance in an async method?

[↑ Content](#content)

Optimize the *wait graph* and allocations, not “add more async.”

- Await native async I/O; never wrap it in `Task.Run`.
- Elide `async` when you only return an inner task (no `using`/`try`/`finally` after it).
- `ConfigureAwait(false)` in libraries to skip context marshaling.
- `ValueTask<T>` on measured hot paths that often complete synchronously.
- Bound concurrency (`SemaphoreSlim`, `Parallel.ForEachAsync`, bounded `Channel<T>`).
- Stream with `IAsyncEnumerable<T>` instead of buffering.
- Pass `CancellationToken` so abandoned work stops.
- Reuse `HttpClient` / pooled sockets; rent buffers from `ArrayPool<T>`.

```csharp
// Elide: no extra state machine.
public Task<User?> GetAsync(int id, CancellationToken ct) => _users.FindAsync(id, ct);

// Keep async: there is cleanup after the inner await.
public async Task<string> LoadAsync(CancellationToken ct)
{
    await using Stream stream = await OpenAsync(ct);
    return await ReadAllAsync(stream, ct);
}
```

Eliding changes exception timing: argument checks in the outer method throw synchronously instead of on a faulted task. Be deliberate.

---

#### AM9. What is the purpose of `ValueTask` and when is it better than `Task`?

[↑ Content](#content)

`ValueTask<T>` avoids allocating a `Task<T>` when the result is often already available (cache, buffered read). It is an optimization, not a default return type.

Rules:

- Await it **exactly once**.
- Do not store it, enumerate it twice, or pass it to `WhenAll` without `.AsTask()`.
- A `ValueTask` backed by `IValueTaskSource` may be reused after it is awaited — awaiting again is undefined.

```csharp
public ValueTask<Packet> ReadAsync(CancellationToken ct)
{
    if (_buffer.TryDequeue(out Packet packet))
        return ValueTask.FromResult(packet);

    return new ValueTask<Packet>(ReadFromSocketAsync(ct));
}
```

Public APIs should stay on `Task<T>` until a profiler shows the allocation on a hot path. See [T6](#t6-valuetask).

---

#### AM10. How does async/await work under the hood in .NET?

[↑ Content](#content)

The compiler rewrites an `async` method into a **state machine** (`IAsyncStateMachine`). `MoveNext` runs the next slice of the method. Each `await` becomes:

1. Get an awaiter (`GetAwaiter()`).
2. If `IsCompleted`, continue synchronously (fast path).
3. Otherwise box/store state, call `UnsafeOnCompleted(continuation)`, and return.
4. On completion, `MoveNext` resumes at the stored state.

`AsyncTaskMethodBuilder` / `AsyncValueTaskMethodBuilder` owns the returned task. `ExecutionContext` is captured and restored on resume so `AsyncLocal<T>` still works. If a `SynchronizationContext` was captured (and `ConfigureAwait(false)` was not used), the continuation is posted back to that context.

That is why `async` methods can `await` anything with the awaiter pattern, not only `Task` — `ValueTask`, custom awaiters, and `yield` in async iterators all plug into the same protocol.

---

### Async Senior (5+ Years)

#### AS1. How does the ThreadPool work with async/await?

[↑ Content](#content)

I/O completions arrive on the I/O completion port (or equivalent) and are queued as work items. Continuations are **ordinary pool work**. While the I/O is outstanding, **no worker is blocked** on that operation.

The pool has global and per-worker local queues, work stealing, and hill-climbing that injects threads when existing workers stay blocked. .NET 10 flushes a worker's local queue to the global queue when that worker is about to block, so stolen work is not stuck behind a blocked thread.

```csharp
// Occupies a worker the whole time — pool sees a blocked thread and may inject another.
byte[] data = File.ReadAllBytes(path);

// Completes via I/O callback; workers are free during the read.
byte[] data = await File.ReadAllBytesAsync(path, ct);
```

Starvation looks like rising queue length and latency while CPU stays low: too many workers blocked on `.Result`, sync I/O, or locks. Raising `SetMinThreads` masks the symptom. See [C2](#c2-process-thread-threadpool-and-task) and [SR4](#sr4-what-causes-threadpool-starvation).

---

#### AS2. Explain `ConfigureAwait(true)` vs `ConfigureAwait(false)` in library vs application code.

[↑ Content](#content)

Default `await` is `ConfigureAwait(true)`: if a `SynchronizationContext` or `TaskScheduler` was captured, the continuation is marshaled back. `ConfigureAwait(false)` skips that marshal; the continuation usually runs on the ThreadPool thread that completed the operation.

| Code | Policy | Why |
|---|---|---|
| Reusable library | `ConfigureAwait(false)` on almost every await | Do not assume a UI/ASP.NET context; avoid deadlocking a caller who blocked |
| UI application | Default / `true` after awaits that touch controls | Button handlers must resume on the UI thread |
| ASP.NET Core app | Either; there is normally **no** request context | False is still correct in libraries you extract; blocking remains forbidden |

```csharp
// Library: never needs the caller's context.
public async Task<int> ChecksumAsync(Stream stream, CancellationToken ct)
{
    byte[] buffer = ArrayPool<byte>.Shared.Rent(4096);
    try
    {
        int read = await stream.ReadAsync(buffer, ct).ConfigureAwait(false);
        return Crc32(buffer.AsSpan(0, read));
    }
    finally
    {
        ArrayPool<byte>.Shared.Return(buffer);
    }
}

// WPF/WinForms: the continuation must see the UI thread.
TitleText.Text = await LoadTitleAsync(id, ct);
```

`ConfigureAwait` does **not** stop `ExecutionContext` / `AsyncLocal<T>` from flowing. .NET 8+ `ConfigureAwait(ConfigureAwaitOptions)` can also force a yield or suppress throwing — know that it exists; do not reach for it in a first-pass answer.

---

#### AS3. How do you design a highly scalable async API?

[↑ Content](#content)

Scalability here means **many concurrent operations with few blocked threads**, plus explicit limits so downstream systems survive.

- Async all the way; no sync-over-async at the boundary.
- Bound outbound concurrency and queue depth ([T8](#t8-bounded-concurrency)).
- Stream large results (`IAsyncEnumerable<T>`, `PipeReader`) instead of buffering.
- Honor `CancellationToken` (in ASP.NET Core, `HttpContext.RequestAborted`).
- Timeouts on every external call.
- Do not share request-scoped non-thread-safe services (`DbContext`, `HttpContext`) across parallel tasks.
- Idempotency keys if the client retries.
- Metrics: in-flight count, queue depth, tail latency — not only averages.

```csharp
app.MapGet("/orders/{id:int}", async (
    int id,
    IOrderService orders,
    CancellationToken ct) =>
{
    Order? order = await orders.GetAsync(id, ct);
    return order is null ? Results.NotFound() : Results.Ok(order);
});
```

A scalable *pipeline* is the same idea with stages: bounded channels, ownership of each message, and backpressure instead of unbounded `WhenAll`. See [SR7](#sr7-how-do-you-design-a-high-throughput-pipeline).

---

#### AS4. What are the potential pitfalls of using async over sync?

[↑ Content](#content)

Async is not free, and wrapping sync code does not make it scalable.

| Pitfall | What goes wrong |
|---|---|
| Fake async (`Task.Run` around `File.ReadAllText`) | Still blocks a worker; extra scheduling |
| State-machine / `Task` allocations | Measurable on extremely hot, already-complete paths |
| Sync-over-async | Deadlock or ThreadPool starvation |
| `async void` | Uncatchable exceptions, untestable completion |
| Fire-and-forget | Lost faults; disposed scopes |
| `await` inside `lock` | Will not compile — and the temptation to block instead is worse |
| Context capture | Unnecessary marshal back to UI / custom scheduler |
| Constructors / `IDisposable.Dispose` | Cannot `await`; blocking inside them reintroduces the problem |
| Debugging | Continuations split the stack; unobserved exceptions hide the cause |

The right move is to expose a **true** async API down to the I/O boundary, and keep CPU work synchronous (or explicitly parallel) where it belongs.

---

#### AS5. How would you handle backpressure in an async stream?

[↑ Content](#content)

Backpressure is how a slow consumer stops a fast producer from unbounded buffering.

- **Bounded `Channel<T>`** with `FullMode.Wait` (or `DropOldest` / `DropWrite` when losing data is acceptable).
- **`IAsyncEnumerable<T>`**: the producer does not run until the consumer `MoveNextAsync`s.
- **`SemaphoreSlim`** to cap in-flight operations.
- HTTP: bounded body reads, `Pipe` options, 429 / Retry-After at the edge.

```csharp
Channel<Job> channel = Channel.CreateBounded<Job>(new BoundedChannelOptions(256)
{
    FullMode = BoundedChannelFullMode.Wait,
    SingleReader = true
});

// Producer waits here when 256 jobs are already queued.
await channel.Writer.WriteAsync(job, ct);

await foreach (Job next in channel.Reader.ReadAllAsync(ct))
    await HandleAsync(next, ct);
```

Unbounded `List<Task>` + `WhenAll` has no backpressure: you have already created every task and opened every connection. See the [channels section](#channels-and-backpressure).

---

#### AS6. Explain how async/await interacts with the ASP.NET Core request pipeline.

[↑ Content](#content)

Kestrel accepts the connection and the pipeline runs on ThreadPool threads. **There is no request `SynchronizationContext`**, unlike classic ASP.NET. Each middleware `InvokeAsync` should `await _next(context)` so the thread is released during downstream I/O.

```csharp
public sealed class TimingMiddleware(RequestDelegate next, ILogger<TimingMiddleware> logger)
{
    public async Task InvokeAsync(HttpContext context)
    {
        long start = Stopwatch.GetTimestamp();
        await next(context);
        logger.LogInformation("Elapsed {Ms} ms", Stopwatch.GetElapsedTime(start).TotalMilliseconds);
    }
}
```

Consequences:

- `.Result` will not usually deadlock on a sync context, but it **will** starve the pool.
- `HttpContext`, `HttpRequest`, and scoped services are **not thread-safe**. `Task.WhenAll` two operations that both use one `DbContext` is a bug.
- `HttpContext.RequestAborted` is the request cancellation token — pass it down.
- Fire-and-forget work must not capture request-scoped services; queue it to a `BackgroundService`.
- After the response starts, some request features are no longer valid.

See [SR8](#sr8-how-do-aspnet-core-concurrency-rules-differ-from-ui-apps).

---

#### AS7. How do you diagnose and troubleshoot performance issues in async applications?

[↑ Content](#content)

Start from the symptom, then prove the wait graph. See [Failure Modes](#failure-modes-and-diagnostics).

| Symptom | First evidence |
|---|---|
| High latency, low CPU | `dotnet-counters` `threadpool-queue-length` and `threadpool-thread-count` — starvation |
| Threads climbing, queue not draining | `dotnet-stack` / dump: workers blocked on `.Result`, sync I/O, or locks |
| Allocations / GC stalls on a hot API | BenchmarkDotNet + traces; look for `Task<T>` and state-machine boxes you can elide/`ValueTask` |
| Hidden faults | Unobserved-task logs; fire-and-forget |

Useful commands: `dotnet-counters monitor -n MyApi System.Runtime System.Threading.ThreadPool`, `dotnet-trace collect --providers Microsoft-DotNETRuntime`. Visual Studio **Parallel Stacks** / **Tasks** windows show which tasks are blocked and on what.

Do not raise `SetMinThreads` or sprinkle `ConfigureAwait(false)` until the trace names the wait.

---

#### AS8. What is `IAsyncDisposable` and when should you use `await using`?

[↑ Content](#content)

`IAsyncDisposable.DisposeAsync` is cleanup that must `await` — complete a channel, flush a network buffer, dispose an async stream. `await using` calls it and waits. See [T12](#t12-iasyncdisposable).

```csharp
public sealed class Producer : IAsyncDisposable
{
    private readonly Channel<Message> _channel = Channel.CreateBounded<Message>(128);
    private readonly Task _pump;

    public Producer() => _pump = PumpAsync();

    public async ValueTask DisposeAsync()
    {
        _channel.Writer.TryComplete();
        await _pump.ConfigureAwait(false);
    }
}

await using Producer producer = new();
```

Use `await using` whenever the type implements `IAsyncDisposable` and the current method is async (`Stream`, `HttpResponseMessage` in some versions, EF `IAsyncEnumerable` enumerators). Do **not** implement `Dispose()` as `DisposeAsync().GetAwaiter().GetResult()`. Prefer `ValueTask` so already-complete disposal does not allocate.

---

#### AS9. How would you handle retries with exponential backoff in async code?

[↑ Content](#content)

Retry only **transient**, **idempotent** failures. Back off exponentially, add jitter so many clients do not retry in lockstep, and honor cancellation during the delay.

```csharp
public async Task<T> WithRetryAsync<T>(
    Func<CancellationToken, Task<T>> action,
    int maxAttempts,
    CancellationToken ct)
{
    TimeSpan delay = TimeSpan.FromMilliseconds(100);

    for (int attempt = 1; ; attempt++)
    {
        try
        {
            return await action(ct);
        }
        catch (Exception ex) when (
            attempt < maxAttempts &&
            IsTransient(ex) &&
            !ct.IsCancellationRequested)
        {
            TimeSpan jittered = delay * Random.Shared.NextDouble();
            await Task.Delay(delay + jittered, ct);
            delay *= 2;
        }
    }
}
```

In production, prefer a library (Polly / Microsoft.Extensions.Http resilience) so timeouts, circuit breakers, and retries compose. Do not retry `POST`s that are not idempotent; do not swallow the last exception; do not retry `OperationCanceledException` from the caller's token.

---

#### AS10. Explain how ExecutionContext flows with async/await and how to control it.

[↑ Content](#content)

`ExecutionContext` is the **logical call context**. It flows automatically across `await` and `Task.Run` so ambient state such as `AsyncLocal<T>`, activity IDs, and security information is restored on the continuation. `SynchronizationContext` is a separate object that `ConfigureAwait` controls. See [T13](#t13-executioncontext-and-asynclocalt).

```csharp
AsyncLocal<string> tenant = new();
tenant.Value = "acme";

await DoWorkAsync(ct);
Console.WriteLine(tenant.Value); // "acme" — ExecutionContext flowed, even with ConfigureAwait(false)

using (ExecutionContext.SuppressFlow())
{
    _ = Task.Run(() => Console.WriteLine(tenant.Value ?? "(none)"));
}
```

Control points:

- **`ExecutionContext.SuppressFlow()`** — stop flow onto a new thread/task (rare; used when a long-lived worker must not inherit request ambient state).
- **`AsyncLocal<T>.Value = null`** — clear ambient data at a fire-and-forget boundary.
- **Do not** store `HttpContext` or a scoped `DbContext` in `AsyncLocal<T>` across a request boundary; the objects will be disposed while the background work still reads them.

Interview distinction that scores: `ConfigureAwait(false)` does **not** suppress ExecutionContext.

---

## Failure Modes and Diagnostics

[↑ Content](#content)

| Symptom | Likely causes | Evidence to collect |
|---|---|---|
| Requests slow, CPU low | ThreadPool starvation, blocked I/O | ThreadPool queue/thread counters, stacks |
| CPU near 100%, throughput flat | Oversubscription, spin/retry, expensive work | CPU trace, thread count, hot methods |
| Operations never complete | Deadlock, lost signal, abandoned task | Parallel stacks, dump, wait chains |
| Memory continually grows | Unbounded queue/tasks, retained `AsyncLocal` | Heap dump, queue depth, allocation trace |
| Rare wrong results | Data race, unsafe publication | Invariant logs, stress test, forced interleavings |
| Poor multicore scaling | Lock contention, false sharing | Contention events, CPU/cache profiling |

Useful .NET tools:

- `dotnet-counters` — ThreadPool thread count, queue length, CPU, exceptions
- `dotnet-trace` / PerfView — scheduling, contention, CPU, runtime events
- `dotnet-stack` — live managed stacks
- `dotnet-dump` — offline dumps and lock/wait inspection
- Visual Studio Parallel Stacks / Tasks — grouped thread and task views
- BenchmarkDotNet — controlled throughput/allocation benchmarks

Diagnose with evidence. Adding locks, retries, delays, or ThreadPool threads before identifying the wait graph often changes timing without fixing correctness.

---

## Common Anti-Patterns

[↑ Content](#content)

| Anti-pattern | Why it fails | Better direction |
|---|---|---|
| `lock(this)`, strings, or public objects | External code can share the lock | Private `Lock` instance |
| `await` under synchronous lock | Thread-bound ownership conflicts with continuation | Async gate or redesign |
| `.Result`, `.Wait()`, `.GetAwaiter().GetResult()` | Deadlock/starvation risk | Async all the way |
| `Task.Run` around async I/O | Extra scheduling, no scalability gain | Await native async API |
| `async void` outside events | No composable completion/error channel | Return `Task` |
| Unbounded `WhenAll` | Resource and downstream exhaustion | Bound concurrency/backpressure |
| `WhenAny` without cancelling losers | Abandoned work keeps running | Cancel remaining tasks |
| Fire-and-forget request task | Scope disposed; exceptions lost | Hosted background queue/service |
| `Task.WaitAsync` timeout without cancelling the inner task | Work continues after you moved on | Linked `CancelAfter` into the API |
| Blocking in `Dispose()` on `DisposeAsync` | Sync-over-async in cleanup | `await using` / `IAsyncDisposable` |
| Retrying non-idempotent or cancelled calls | Duplicate side effects; noisy shutdown | Transient + idempotent only; honor `ct` |
| Locking each field separately | Multi-field invariant can tear | One coherent lock/snapshot |
| Assuming concurrent collection makes workflow atomic | Only individual operations are atomic | Atomic API or external coordination |
| Holding a lock across I/O/callback | Long contention and reentrancy/deadlock | Copy state, release, then call |
| Using `volatile` for `x++` | Visibility is not compound atomicity | `Interlocked` |
| Parallelizing tiny work | Scheduling/merge cost dominates | Keep sequential; benchmark |
| Cancellation swallowed as success | Callers cannot distinguish cancellation | Propagate matching cancellation |
| Sleeping to coordinate | Timing-dependent and blocks threads | Signals, tasks, channels |

---

## Rapid Interview Answers

[↑ Content](#content)

- **Task vs thread:** Task models completion; thread is an execution resource.
- **Async vs parallel:** Async avoids blocking while waiting; parallel uses simultaneous execution.
- **Best modern lock:** Private `System.Threading.Lock` with `lock` for synchronous critical sections.
- **Can `await` be inside `lock`?** No; use an async-compatible design such as `SemaphoreSlim`.
- **Atomic increment:** `Interlocked.Increment`.
- **Safe cancellation:** Cooperative `CancellationToken`, propagated end to end.
- **Producer/consumer:** Prefer bounded `Channel<T>` for async pipelines.
- **Protect a dictionary:** `ConcurrentDictionary` for atomic per-key operations; lock larger invariants.
- **Avoid context deadlock:** Do not block on tasks; await them.
- **ThreadPool starvation:** Workers are blocked, so queued continuations/work wait.
- **Parallel CPU degree:** Start near processor count and measure.
- **Parallel I/O degree:** Bound according to downstream/resource capacity.
- **Safest shared state:** No shared mutable state—immutability, ownership, partitioning.
- **`volatile` vs `Interlocked`:** Visibility/order vs atomic read-modify-write.
- **`WhenAll`:** Concurrently wait for all already-started tasks; bound large workloads.
- **`WhenAny` vs `WhenEach`:** first completion vs yield each task as it finishes (.NET 9+).
- **`async void`:** event handlers only; cannot await; exceptions crash the context.
- **Unawaited task:** work is already running; exceptions and completion are unobserved.
- **`Thread.Sleep` vs `Task.Delay`:** blocks a thread vs timer + freed thread.
- **Timeout:** linked `CancellationTokenSource.CancelAfter`, not only `WaitAsync`.
- **Library `ConfigureAwait`:** `false`; UI code that touches controls: default/`true`.
- **ExecutionContext vs SyncContext:** ExecutionContext (`AsyncLocal`) always flows; `ConfigureAwait(false)` only skips marshaling.
- **`IAsyncEnumerable<T>`:** async pull; natural backpressure; not `Task<List<T>>`.
- **`await using`:** `IAsyncDisposable` when cleanup itself must await.

---

## Self-Check Checklist

[↑ Content](#content)

**Foundations**

- [ ] Explain concurrency, parallelism, asynchrony, and multithreading
- [ ] Explain why a task is not a thread
- [ ] Distinguish CPU-bound and I/O-bound work
- [ ] Identify a race and the invariant being violated
- [ ] Explain atomicity, visibility, ordering, and happens-before

**Synchronization**

- [ ] Use private `System.Threading.Lock` correctly
- [ ] Explain `Monitor.Wait` releasing and reacquiring the monitor
- [ ] Choose between `Interlocked`, `Volatile`, lock, and semaphore
- [ ] Explain why `await` cannot occur in `lock`
- [ ] Recognize when cross-process `Mutex` is required
- [ ] Explain why reader/writer locks require benchmarking

**Tasks and async**

- [ ] Explain the async state-machine flow
- [ ] Contrast `Task`, `Task<T>`, `ValueTask`, and `async void`
- [ ] Contrast `Task.Run` with `async`/`await` and CPU-bound vs I/O-bound work
- [ ] Use `WhenAll`, `WhenAny`, `WhenEach`, and cancellation correctly
- [ ] Implement a timeout that actually cancels the underlying operation
- [ ] Explain sync-over-async deadlock and starvation
- [ ] Bound concurrency and apply backpressure (`Channel`, `IAsyncEnumerable<T>`)
- [ ] Know when `ValueTask` is justified and its await-once rule
- [ ] Explain context capture, `ConfigureAwait`, and ExecutionContext flow
- [ ] Use `IAsyncDisposable` / `await using` instead of blocking in `Dispose`
- [ ] Sketch retries with exponential backoff and jitter

**Architecture and diagnostics**

- [ ] Prefer immutability, ownership, and channels over shared state
- [ ] Explain deadlock, livelock, starvation, and false sharing
- [ ] Diagnose ThreadPool starvation from counters and stacks
- [ ] Avoid sharing non-thread-safe scoped services across parallel work
- [ ] Test invariants with controlled interleavings rather than sleeps
- [ ] Measure contention, throughput, allocations, and tail latency

---

## Glossary

[↑ Content](#content)

| Term | Short definition |
|---|---|
| **Async iterator** | Compiler-generated `IAsyncEnumerable<T>` from `async` + `yield return` |
| **Atomic operation** | Operation observed as indivisible |
| **Awaiter** | Object with `IsCompleted`, `OnCompleted`, and `GetResult` that `await` consumes |
| **Backpressure** | Consumers limit producers so queued work stays bounded |
| **Cancellation** | Cooperative request to stop work |
| **Contention** | Multiple participants compete for one resource |
| **Continuation** | Delegate that resumes an async method after an await completes |
| **Critical section** | Code that must execute with controlled concurrency |
| **Deadlock** | Cyclic waiting with no possible progress |
| **Eliding async** | Returning an inner `Task` without an `async` state machine on the outer method |
| **ExecutionContext** | Logical call context (`AsyncLocal<T>`, security) that flows across await |
| **False sharing** | Independent writes contend on one hardware cache line |
| **Happens-before** | Ordering relation that guarantees visibility of prior writes |
| **Hot task** | A `Task` whose work has already started when the caller receives it |
| **Livelock** | Active participants repeatedly react but make no progress |
| **Lock-free** | At least one operation always makes system-wide progress |
| **Parallelism** | Work executes simultaneously |
| **Race condition** | Correctness depends on unpredictable interleaving |
| **Safe publication** | Making initialized state visible with correct ordering |
| **Starvation** | Work is indefinitely denied execution/resources |
| **State machine** | Compiler rewrite of an `async` method into `IAsyncStateMachine.MoveNext` |
| **SynchronizationContext** | Policy for scheduling continuations to an environment |
| **Sync-over-async** | Blocking on a `Task` (`.Result`/`.Wait()`) from synchronous code |
| **Thread affinity** | Requirement that code/resource be accessed by one thread |
| **ThreadPool** | Runtime-managed reusable worker-thread pool |
| **ValueTask** | Struct that can hold a result or wrap a `Task`, avoiding an allocation |
| **Wait-free** | Every operation completes in bounded steps |

---

*Study path: mental models → synchronization semantics → task composition → async/await interview ladder (AJ/AM/AS) → bounded pipelines → failure diagnosis. Practice by deliberately reproducing a lost update, a lock-order deadlock, sync-over-async blocking, an unawaited fault, and ThreadPool starvation—then fix each with the smallest correct design.*
