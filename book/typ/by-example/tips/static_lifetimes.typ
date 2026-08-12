#import "../../config.typ": *

#h1((en: ['static super-powers]
), offset: whole*2)

In `#[init]`, `#[idle]` and divergent software tasks `local` resources
have `'static` lifetime.

Useful when pre-allocating and/or splitting resources between tasks,
drivers or some other object. This comes in handy when drivers, such as
USB drivers, need to allocate memory and when using splittable data
structures such as
#link("https://docs.rs/heapless/0.7.5/heapless/spsc/struct.Queue.html")[`heapless::spsc::Queue`].

In the following example two different tasks share a
#link("https://docs.rs/heapless/0.7.5/heapless/spsc/struct.Queue.html")[`heapless::spsc::Queue`]
for lock-free access to the shared queue.

#include-code("../../examples/lm3s6965/examples/static-resources-in-init.rs")

Running this program produces the expected output.

```console
$ cargo xtask qemu --verbose --example static-resources-in-init
```
#include-code("../../ci/expected/lm3s6965/static-resources-in-init.run")
