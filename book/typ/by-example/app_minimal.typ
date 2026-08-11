#import "../config.typ": *

#h1((en: [The minimal app]
), offset: whole)

This is the smallest possible RTIC application:

#include-code("../../examples/lm3s6965/examples/smallest.rs")

RTIC is designed with resource efficiency in mind. RTIC itself does not
rely on any dynamic memory allocation, thus RAM requirement is dependent
only on the application. The flash memory footprint is below 1kB
including the interrupt vector table.

For a minimal example you can expect something like:

```shell
$ cargo xtask size --example smallest --backend thumbv7
```

#include-code("../../ci/expected/lm3s6965/smallest.size", lang: "shell")
