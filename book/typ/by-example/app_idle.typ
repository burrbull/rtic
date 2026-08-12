#import "../config.typ": *

#h1((en: [The background task `#[idle]`],
), offset: whole)

A function marked with the `idle` attribute can optionally appear in the
module. This becomes the special _idle task_ and must have
signature `fn(idle::Context) -> !`.

When present, the runtime will execute the `idle` task after `init`.
Unlike `init`, `idle` will run #emph[with interrupts enabled] and must
never return, as the `-> !` function signature indicates.
#link("https://doc.rust-lang.org/core/primitive.never.html")[The Rust type `!` means "never"].

Like in `init`, locally declared resources will have `'static` lifetimes
that are safe to access.

The example below shows that `idle` runs after `init`.

#include-code("../../examples/lm3s6965/examples/idle.rs")

```console
$ cargo xtask qemu --verbose --example idle
```
#include-code("../../ci/expected/lm3s6965/idle.run")

By default, the RTIC `idle` task does not try to optimize for any
specific targets.

A common useful optimization is to enable the
#link("https://developer.arm.com/documentation/100737/0100/Power-management/Sleep-mode/Sleep-on-exit-bit")[SLEEPONEXIT]
and allow the MCU to enter sleep when reaching `idle`.

#quote(block: true)[
*Caution*: some hardware unless configured disables the debug
unit during sleep mode.

Consult your hardware specific documentation as this is outside the
scope of RTIC.
]

The following example shows how to enable sleep by setting the
#link("https://developer.arm.com/documentation/100737/0100/Power-management/Sleep-mode/Sleep-on-exit-bit")[`SLEEPONEXIT`]
and providing a custom `idle` task replacing the default
#link("https://developer.arm.com/documentation/dui0662/b/The-Cortex-M0--Instruction-Set/Miscellaneous-instructions/NOP")[`nop()`]
with
#link("https://developer.arm.com/documentation/dui0662/b/The-Cortex-M0--Instruction-Set/Miscellaneous-instructions/WFI")[`wfi()`].


#include-code("../../examples/lm3s6965/examples/idle-wfi.rs")

```console
$ cargo xtask qemu --verbose --example idle-wfi
```
#include-code("../../ci/expected/lm3s6965/idle-wfi.run")

#quote(block: true)[
*Notice*: The `idle` task cannot be used together with
_software_ tasks running at priority zero. The reason is that
`idle` is running as a non-returning Rust function at priority zero.
Thus there would be no way for an executor at priority zero to give
control to _software_ tasks at the same priority.
]
