#import "../config.typ": *

#h1((en: [Communication over channels.]
), offset: whole)

Channels can be used to communicate data between running tasks. The
channel is essentially a wait queue, allowing tasks with multiple
producers and a single receiver. A channel is constructed in the `init`
task and backed by statically allocated memory. Send and receive
endpoints are distributed to #emph[software] tasks:

```rust
...
const CAPACITY: usize = 5;
#[init]
    fn init(_: init::Context) -> (Shared, Local) {
        let (s, r) = make_channel!(u32, CAPACITY);
        receiver::spawn(r).unwrap();
        sender1::spawn(s.clone()).unwrap();
        sender2::spawn(s.clone()).unwrap();
        ...
```

In this case the channel holds data of `u32` type with a capacity of 5
elements.

Channels can also be used from #emph[hardware] tasks, but only in a
non-`async` manner using the #link(<try-api>)[Try API].

= Sending data
<sending-data>
The `send` method post a message on the channel as shown below:

```rust
#[task]
async fn sender1(_c: sender1::Context, mut sender: Sender<'static, u32, CAPACITY>) {
    hprintln!("Sender 1 sending: 1");
    sender.send(1).await.unwrap();
}
```

= Receiving data
<receiving-data>
The receiver can `await` incoming messages:

```rust
#[task]
async fn receiver(_c: receiver::Context, mut receiver: Receiver<'static, u32, CAPACITY>) {
    while let Ok(val) = receiver.recv().await {
        hprintln!("Receiver got: {}", val);
        ...
    }
}
```

Channels are implemented using a small (global) #emph[Critical Section]
(CS) for protection against race-conditions. The user must provide an CS
implementation. For the examples a CS implementation is provided by a
platform crate, for example `cortex-m/critical-section-single-core` or
`esp32c3/critical-section`.

For a complete example:

```rust
{{#include ../../../../examples/lm3s6965/examples/async-channel.rs}}
```

```console
$ cargo xtask qemu --verbose --example async-channel
```

```console
{{#include ../../../../ci/expected/lm3s6965/async-channel.run}}
```

Also sender endpoint can be awaited. In case the channel capacity has
not yet been reached, `await`-ing the sender can progress immediately,
while in the case the capacity is reached, the sender is blocked until
there is free space in the queue. In this way data is never lost.

In the following example the `CAPACITY` has been reduced to 1, forcing
sender tasks to wait until the data in the channel has been received.

```rust
{{#include ../../../../examples/lm3s6965/examples/async-channel-done.rs}}
```

Looking at the output, we find that `Sender 2` will wait until the data
sent by `Sender 1` as been received.

#quote(block: true)[
#strong[NOTICE] #emph[Software] tasks at the same priority are executed
asynchronously to each other, thus #strong[NO] strict order can be
assumed. (The presented order here applies only to the current
implementation, and may change between RTIC framework releases.)
]

```console
$ cargo xtask qemu --verbose --example async-channel-done
{{#include ../../../../ci/expected/lm3s6965/async-channel-done.run}}
```

= Error handling
<error-handling>
In case all senders have been dropped `await`-ing on an empty receiver
channel results in an error. This allows to gracefully implement
different types of shutdown operations.

```rust
{{#include ../../../../examples/lm3s6965/examples/async-channel-no-sender.rs}}
```

```console
$ cargo xtask qemu --verbose --example async-channel-no-sender
```

```console
{{#include ../../../../ci/expected/lm3s6965/async-channel-no-sender.run}}
```

Similarly, `await`-ing on a send channel results in an error in case the
receiver has been dropped. This allows to gracefully implement
application level error handling.

The resulting error returns the data back to the sender, allowing the
sender to take appropriate action (e.g., storing the data to later retry
sending it).

```rust
{{#include ../../../../examples/lm3s6965/examples/async-channel-no-receiver.rs}}
```

```console
$ cargo xtask qemu --verbose --example async-channel-no-receiver
```

```console
{{#include ../../../../ci/expected/lm3s6965/async-channel-no-receiver.run}}
```

= Try API
<try-api>
Using the Try API, you can send or receive data from or to a channel
without requiring that the operation succeeds, and in non-`async`
contexts.

This API is exposed through `Receiver::try_recv` and `Sender::try_send`.

```rust
{{#include ../../../../examples/lm3s6965/examples/async-channel-try.rs}}
```

```console
$ cargo xtask qemu --verbose --example async-channel-try
```

```console
{{#include ../../../../ci/expected/lm3s6965/async-channel-try.run}}
```
