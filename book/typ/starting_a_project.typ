#import "config.typ": *

#h1((en: [Starting a new project]
))

A recommendation when starting a RTIC project from scratch is to follow
RTIC's
#link("https://github.com/rtic-rs/defmt-app-template")[`defmt-app-template`].

If you are targeting ARMv6-M or ARMv8-M-base architecture, check out the
section #link("./internals/targets.md")[Target Architecture] for more
information on hardware limitations to be aware of.

This will give you an RTIC application with support for RTT logging with
#link("https://github.com/knurling-rs/defmt/")[`defmt`] and stack
overflow protection using
#link("https://github.com/knurling-rs/flip-link/")[`flip-link`]. There
is also a multitude of examples provided by the community:

For inspiration, you may look at the
#link("https://github.com/rtic-rs/rtic/tree/master/examples")[RTIC examples].

= RTIC on RISC-V devices
<rtic-on-risc-v-devices>
Even though RTIC was initially developed for ARM Cortex-M, it is
possible to use RTIC on RISC-V devices. However, the RISC-V ecosystem is
more heterogeneous. To tackle this issue, currently, RTIC implements
three different backends:

- #strong[`riscv-esp32c3-backend`]: This backend provides support for
  the ESP32-C3 SoC. In these devices, RTIC is very similar to its
  Cortex-M counterpart.

- #strong[`riscv-esp32c6-backend`]: This backend provides support for
  the ESP32-C6 SoC. In these devices, RTIC is very similar to its
  Cortex-M counterpart.

- #strong[`riscv-mecall-backend`]: This backend provides support for
  #strong[any] RISC-V device. In this backend, pending tasks trigger
  Machine Environment Call exceptions. The handler for this exception
  source dispatches pending tasks according to their priority. The
  behavior of this backend is equivalent to `riscv-clint-backend`. The
  main difference of this backend is that all the tasks #strong[must be]
  #link("./by-example/software_tasks.md")[software tasks]. Additionally,
  it is not required to provide a list of dispatchers in the `#[app]`
  attribute, as RTIC will generate them at compile time.

- #strong[`riscv-clint-backend`]: This backend supports devices with a
  CLINT peripheral. It is equivallent to `riscv-mecall-backend`, but
  instead of triggering exceptions, it triggers software interrupts via
  the `MSIP` register of the CLINT.
