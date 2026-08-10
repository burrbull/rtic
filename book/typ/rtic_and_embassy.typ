#import "config.typ": *

#h1((en: [RTIC vs.~Embassy]
))

= Differences
<differences>
Embassy provides both Hardware Abstraction Layers, and an
executor/runtime, while RTIC aims to only provide an execution
framework. For example, embassy provides `embassy-stm32` (a HAL), and
`embassy-executor` (an executor). On the other hand, RTIC provides the
framework in the form of
#link("https://docs.rs/rtic/latest/rtic/")[`rtic`], and the user is
responsible for providing a PAC and HAL implementation (generally from
the #link("https://github.com/stm32-rs")[`stm32-rs`] project).

Additionally, RTIC aims to provide exclusive access to resources at as
low a level as possible, ideally guarded by some form of hardware
protection. This allows for access to hardware without necessarily
requiring locking mechanisms at the software level.

= Mixing use of Embassy and RTIC
<mixing-use-of-embassy-and-rtic>
Since most Embassy and RTIC libraries are runtime agnostic, many details
from one project can be used in the other. For example, using
#link("https://docs.rs/rtic-monotonics/latest/rtic_monotonics/")[`rtic-monotonics`]
in an `embassy-executor` powered project works, and using
#link("https://docs.rs/embassy-sync/latest/embassy_sync/")[`embassy-sync`]
(though
#link("https://docs.rs/rtic-sync/latest/rtic_sync/")[`rtic-sync`] is
recommended) in an RTIC project works.
