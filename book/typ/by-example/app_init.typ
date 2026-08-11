#import "../config.typ": *

#h1((en: [App initialization and the `#[init]` task]
), offset: whole)

An RTIC application requires an `init` task setting up the system. The
corresponding `init` function must have the signature
`fn(init::Context) -> (Shared, Local)`, where `Shared` and `Local` are
resource structures defined by the user.

The `init` task executes after system reset, \[after an optionally
defined `pre-init` code
section\]//#footnote[#link("https://docs.rs/cortex-m-rt/latest/cortex_m_rt/attr.pre_init.html")]
and an always occurring internal RTIC initialization.

The `init` and optional `pre-init` tasks runs #emph[with interrupts
disabled] and have exclusive access to Cortex-M (the
`critical_section::CriticalSection` token is available as `cs`).

Device specific peripherals are available through the `core` and
`device` fields of `init::Context`.

= Example

The example below shows the types of the `core`, `device` and `cs`
fields, and showcases the use of a `local` variable with `'static`
lifetime. Such variables can be delegated from the `init` task to other
tasks of the RTIC application.

The `device` field is only available when the `peripherals` argument is
set to the default value `true`. In the rare case you want to implement
an ultra-slim application you can explicitly set `peripherals` to
`false`.

#include-code("../../examples/lm3s6965/examples/init.rs")

Running the example will print `init` to the console and then exit the
QEMU process.

```shell
$ cargo xtask qemu --verbose --example init
```

#include-code("../../ci/expected/lm3s6965/init.run", lang: "shell")
