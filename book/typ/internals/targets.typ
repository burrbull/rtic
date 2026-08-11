#import "../config.typ": *

#h1((en: [Target Architecture]
), offset: whole)
<target-architecture>

= Cortex-M Devices

While RTIC can currently target all Cortex-m devices there are some key
architecture differences that users should be aware of. Namely, the
absence of Base Priority Mask Register (`BASEPRI`) which lends itself
exceptionally well to the hardware priority ceiling support used in
RTIC, in the ARMv6-M and ARMv8-M-base architectures, which forces RTIC
to use source masking instead. For each implementation of lock and a
detailed commentary of pros and cons, see the implementation of
#link("https://github.com/rtic-rs/rtic/blob/master/rtic/src/export.rs")[lock in src/export.rs].

These differences influence how critical sections are realized, but
functionality should be the same except that ARMv6-M/ARMv8-M-base cannot
have tasks with shared resources bound to exception handlers, as these
cannot be masked in hardware.

@t:arm-critical-section below shows a list of Cortex-m processors and which type of
critical section they employ.

#figure(
  kind: table,
  caption: [Critical Section Implementation by Processor Architecture],
  table(
    columns: 4,
    align: (left,center,center,center,),
    table.header([Processor], [Architecture], [Priority
      Ceiling], [Source Masking],),
    table.hline(),
    [Cortex-M0], [ARMv6-M], [], [✓],
    [Cortex-M0+], [ARMv6-M], [], [✓],
    [Cortex-M3], [ARMv7-M], [✓], [],
    [Cortex-M4], [ARMv7-M], [✓], [],
    [Cortex-M7], [ARMv7-M], [✓], [],
    [Cortex-M23], [ARMv8-M-base], [], [✓],
    [Cortex-M33], [ARMv8-M-main], [✓], [],
  )
) <t:arm-critical-section>

== Priority Ceiling

This is covered by the #link("../by-example/resources.html")[Resources]
page of this book.

== Source Masking

Without a `BASEPRI` register which allows for directly setting a
priority ceiling in the Nested Vectored Interrupt Controller (NVIC),
RTIC must instead rely on disabling (masking) interrupts. Consider
@f:source-masking below, showing two tasks A and B where A has higher priority
but shares a resource with B.

#figure(
  kind: image,
  caption: [Shared Resources and Source Masking],
  ```text
    ┌────────────────────────────────────────────────────────────────┐
    │                                                                │
    │                                                                │
  3 │                   Pending    Preempts                          │
  2 │             ↑- - -A- - - - -↓A─────────►                       │
  1 │          B───────────────────► - - - - B────────►              │
  0 │Idle┌─────►                             Resumes  ┌────────►     │
    ├────┴────────────────────────────────────────────┴──────────────┤
    │                                                                │
    └────────────────────────────────────────────────────────────────┴──► Time
                  t1    t2        t3         t4
  ```
) <f:source-masking>

At time _t1_, task B locks the shared resource by selectively
disabling (using the NVIC) all other tasks which have a priority equal
to or less than any task which shares resources with B. In effect this
creates a virtual priority ceiling, mirroring the `BASEPRI` approach.
Task A is one such task that shares resources with task B. At time
_t2_, task A is either spawned by task B or becomes pending through
an interrupt condition, but does not yet preempt task B even though its
priority is greater. This is because the NVIC is preventing it from
starting due to task A being disabled. At time _t3_, task B
releases the lock by re-enabling the tasks in the NVIC. Because task A
was pending and has a higher priority than task B, it immediately
preempts task B and is free to use the shared resource without risk of
data race conditions. At time _t4_, task A completes and returns
the execution context to B.

Since source masking relies on use of the NVIC, core exception sources
such as HardFault, SVCall, PendSV, and SysTick cannot share data with
other tasks.

= RISC-V Devices

All the current RISC-V backends work in a similar way as Cortex-M
devices with priority ceiling. Therefore, the
#link("../by-example/resources.html")[Resources] page of this book is a
good reference. However, some of these backends are not full hardware
implementations, but use software to emulate a physical interrupt
controller. Therefore, these backends do not implement hardware tasks,
and only software tasks are needed. Furthermore, the number of software
tasks for these targets is not bounded by the number of available
physical interrupt sources.

@t:riscv-backends below compares the available RISC-V backends.

#figure(
  kind: table,
  caption: [Critical Section Implementation by Processor Architecture],
  table(
    columns: (16.55%, 20.86%, 21.58%, 10.07%, 10.07%, 20.86%),
    align: (center,center,center,center,center,center,),
    table.header([Backend], [Compatible targets], [Backend-specific
      configuration], [Hardware Tasks], [Software Tasks], [Number of
      tasks bounded by HW],),
    table.hline(),
    [`riscv-esp32c3-backend`], [ESP32-C3 only], [], [✓], [✓], [✓],
    [`riscv-mecall-backend`], [Any RISC-V device], [], [], [✓], [],
    [`riscv-clint-backend`], [Devices with CLINT
    peripheral], [✓], [], [✓], [],
  )
) <t:riscv-backends>

== `riscv-mecall-backend`

It is not necessary to provide a list of dispatchers in the `#[app]`
attribute, as RTIC will generate them at compile time. Priority levels
can go from 0 (for the `idle` task) to 255.

== `riscv-clint-backend`

It is not necessary to provide a list of `dispatchers` in the `#[app]`
attribute, as RTIC will generate them at compile time. Priority levels
can go from 0 (for the `idle` task) to 255.

You *must* include a `backend`-specific configuration in the
`#[app]` attribute so RTIC knows the ID number used to identify the HART
running your application. For example, for `e310x` chips, you would
configure a minimal application as follows:

```rust
#[rtic::app(device = e310x, backend = H0)]
mod app {
  // your application here
}
```

In this way, RTIC will always refer to HART `H0`.
