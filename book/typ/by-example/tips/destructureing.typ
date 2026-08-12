#import "../../config.typ": *

#h1((en: [Resource de-structure-ing]
), offset: whole*2)

Destructuring task resources might help readability if a task takes
multiple resources. Here are two examples on how to split up the
resource struct:

#include-code("../../examples/lm3s6965/examples/destructure.rs")

```console
$ cargo xtask qemu --verbose --example destructure
```
#include-code("../../ci/expected/lm3s6965/destructure.run")
