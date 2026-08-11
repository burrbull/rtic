#import "../config.typ": *

#h1((en: [Delay and Timeout using Monotonics]
), offset: whole)

A convenient way to express miniminal timing requirements is by delaying
progression.

This can be achieved by instantiating a monotonic timer (for
implementations, see
#link("https://github.com/rtic-rs/rtic/tree/master/rtic-monotonics")[`rtic-monotonics`]).
Monotonics can be thought of like timekeepers, they measure the amount
of time elapsed since the start of the monotonic (usually the start of
the application). In RTIC, monotonics can be used for delaying the
execution of code and for time measurement.

All monotonic implementations in RTIC are guaranteed to remain stable
longer than the lifetime of the hardware, i.e.~you can theoretically
delay a task for multiple years and it should execute successfully
(presuming there's no hardware failure). The resolution of the monotonic
(i.e.~the smallest possible delay that you can sleep) depends on the
implementation. Many monotonic implementations also allow you to control
the resolution by setting a prescaler for the hardware timer. This is
documented in the
#link("https://docs.rs/rtic-monotonics/latest/rtic_monotonics/#modules")[crate docs of the individual `rtic-monotonics`].

= Delay

#include-code(
    prefix: "...\n",
    "../../examples/lm3s6965/examples/async-timeout.rs",
    anchor: "init",
    suffix: "\n        ...",
)

A _software_ task can `await` the delay to expire:

```rust
#[task]
async fn foo(_cx: foo::Context) {
    ...
    Mono::delay(100.millis()).await;
    ...
}
```

A complete example
#include-code("../../examples/lm3s6965/examples/async-delay.rs")

```shell
$ cargo xtask qemu --verbose --example async-delay
```

#include-code("../../ci/expected/lm3s6965/async-delay.run", lang: "shell")

#quote(block: true)[
Interested in contributing new implementations of
#link("https://docs.rs/rtic-time/latest/rtic_time/trait.Monotonic.html")[`Monotonic`],
or more information about the inner workings of monotonics? Check out
the #link(<implementing-monotonic>)[Implementing a `Monotonic`] chapter!
]

= Timeout

Rust
#link("https://doc.rust-lang.org/std/future/trait.Future.html")[`Future`]s
(underlying Rust `async`/`await`) are composable. This makes it possible
to `select` in between `Futures` that have completed.

A common use case is transactions with an associated timeout. In the
examples shown below, we introduce a fake HAL device that performs some
imagined transaction when you call `hal_get(n).await`. We have modelled
the time it takes based on the input parameter (`n`) as
`350ms + n * 100ms`.

Using the `select_biased` macro from the `futures` crate it may look
like this:

#include-code(
    "../../examples/lm3s6965/examples/async-timeout.rs",
    anchor: "select_biased",
)

Assuming the `hal_get` will take 450ms to finish, a short timeout of
200ms will expire before `hal_get` can complete.

Extending the timeout to 1000ms would cause `hal_get` will to complete
first.

Using `select_biased` any number of futures can be combined, so its very
powerful. However, as the timeout pattern is frequently used, more
ergonomic support is baked into RTIC, provided by the
#link("https://github.com/rtic-rs/rtic/tree/master/rtic-monotonics")[`rtic-monotonics`]
and
#link("https://github.com/rtic-rs/rtic/tree/master/rtic-time")[`rtic-time`]
crates. Here's another example, using `Mono::delay_until` and
`Mono::timeout_after`:

#include-code(
    "../../examples/lm3s6965/examples/async-timeout.rs",
    anchor: "timeout_at_basic",
)

In cases where you want exact control over time without drift we can use
exact points in time using `Instant`, and spans of time using
`Duration`. Operations on the `Instant` and `Duration` types come from
the #link("https://crates.io/crates/fugit")[`fugit`] crate.

`let mut instant = Mono::now()` sets the starting time of execution.

We want to call `hal_get` every 1000ms relative to this starting time.
We accomplish this by incrementing our `instant` by 1000 ms and then
using `Mono::delay_until(instant).await`. Any additional delays incurred
as we iterate around this loop are compensated for by delaying until
'previous + 1000' as opposed to 'now + 1000' (which would cause our loop
timing to drift).

To show an alternative to the `select!` async timeout example above, we
define a future point in time as `timeout`, and call
`Mono::timeout_at(timeout, hal_get(n)).await`.

For the first iteration of the loop, with `n == 0`, the `hal_get` will
take 350ms (as described above), and finishes before the timeout. For
the second iteration, the delay is 450ms, which still finishes before
the timeout. For the third iteration, with `n == 2`, `hal_get` will take
550ms to finish, in which case we will run into a timeout.

A complete example
#include-code("../../examples/lm3s6965/examples/async-timeout.rs")

#include-code(
    lang: "shell",
    prefix: "$ cargo xtask qemu --verbose --example async-timeout\n",
    "../../ci/expected/lm3s6965/async-timeout.run",
)
