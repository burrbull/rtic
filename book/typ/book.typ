#import "config.typ": *
#import "../../typbook/lib.typ": book

#set figure.caption(position: top)

#let sources = (
  "preface": (
    content: include "preface.typ",
    title: tr((
      en: [Preface],
    )),
  ),
  "starting_a_project": (
    content: include "starting_a_project.typ",
    title: tr((
      en: [Starting a new project],
    )),
  ),
  "by-example": (
    content: include "by-example.typ",
    title: tr((
      en: [RTIC by example],
    )),
    sub: (
      "by-example/app": (
        content: include "by-example/app.typ",
        title: tr((
          en: [The `app`],
        )),
      ),
      "by-example/hardware_taskspp": (
        content: include "by-example/hardware_tasks.typ",
        title: tr((
          en: [Hardware tasks],
        )),
      ),
      "by-example/software_tasks": (
        content: include "by-example/software_tasks.typ",
        title: tr((
          en: [Software tasks & `spawn`],
        )),
      ),
      "by-example/resources": (
        content: include "by-example/resources.typ",
        title: tr((
          en: [Resources],
        )),
      ),
      "by-example/app_init": (
        content: include "by-example/app_init.typ",
        title: tr((
          en: [The init task],
        )),
      ),
      "by-example/app_idle": (
        content: include "by-example/app_idle.typ",
        title: tr((
          en: [The idle task],
        )),
      ),
      "by-example/channel": (
        content: include "by-example/channel.typ",
        title: tr((
          en: [Channel based communication],
        )),
      ),
      "by-example/delay": (
        content: include "by-example/delay.typ",
        title: tr((
          en: [Delay and Timeout using Monotonics],
        )),
      ),
      "by-example/app_minimal": (
        content: include "by-example/app_minimal.typ",
        title: tr((
          en: [The minimal app],
        )),
      ),
      "by-example/tips/index": (
        content: include "by-example/tips/index.typ",
        title: tr((
          en: [Tips & Trick],
        )),
        sub: (
          "by-example/tips/destructureing": (
            content: include "by-example/tips/destructureing.typ",
            title: [Resource de-structure-ing]
          ),
          "by-example/tips/indirection": (
            content: include "by-example/tips/indirection.typ",
            title: [Avoid copies when message passing]
          ),
          "by-example/tips/static_lifetimes": (
            content: include "by-example/tips/static_lifetimes.typ",
            title: [static super-powers]
          ),
          "by-example/tips/view_code": (
            content: include "by-example/tips/view_code.typ",
            title: [Inspecting generated code]
          ),
        )
      ),
      /*"by-example/message_passing": (
        content: include "by-example/message_passing.typ",
        title: tr((
          en: [Message passing & `capacity`],
        )),
      ),
      "by-example/app_priorities": (
        content: include "by-example/app_priorities.typ",
        title: tr((
          en: [Task priorities],
        )),
      ),*/
    ),
  ),
  "monotonic_impl": (
    content: include "monotonic_impl.typ",
    title: tr((
      en: [Monotonics & the Timer Queue],
    )),
  ),
  "rtic_vs": (
    content: include "rtic_vs.typ",
    title: tr((
      en: [RTIC vs.~the world],
    )),
  ),
  "rtic_and_embassy": (
    content: include "rtic_and_embassy.typ",
    title: tr((
      en: [RTIC and Embassy],
    )),
  ),
  "awesome_rtic": (
    content: include "awesome_rtic.typ",
    title: tr((
      en: [Awesome RTIC examples],
    )),
  ),
  "migration_v1_v2": (
    content: include "migration_v1_v2.typ",
    title: tr((
      en: [Migrating from v1.0.x to v2.0.0],
    )),
    sub: (
      "migration_v1_v2/monotonics": (
        content: include "migration_v1_v2/monotonics.typ",
        title: tr((
          en: [Migrating to `rtic-monotonics`],
        )),
      ),
      "migration_v1_v2/async_tasks": (
        content: include "migration_v1_v2/async_tasks.typ",
        title: tr((
          en: [Software tasks must now be `async`],
        )),
      ),
      "migration_v1_v2/rtic-sync": (
        content: include "migration_v1_v2/rtic-sync.typ",
        title: tr((
          en: [Using and understanding `rtic-sync`],
        )),
      ),
      "migration_v1_v2/complete_example": (
        content: include "migration_v1_v2/complete_example.typ",
        title: tr((
          en: [A code example on migration],
        )),
      ),
    )
  ),
  "internals": (
    content: include "internals.typ",
    title: tr((
      en: [Under the hood],
    )),
    sub: (
      "internals/targets": (
        content: include "internals/targets.typ",
        title: tr((
          en: [Target architectures]
        )),
      ),
      /*"internals/interrupt-configuration": (
        content: include "internals/interrupt-configuration.typ",
        title: tr((
          en: [Interrupt configuration]
        )),
      ),
      "internals/non-reentrancy": (
        content: include "internals/non-reentrancy.typ",
        title: tr((
          en: [Non-reentrancy]
        )),
      ),
      "internals/late-resources": (
        content: include "internals/late-resources.typ",
        title: tr((
          en: [Late resources]
        )),
      ),
      "internals/critical-sections": (
        content: include "internals/critical-sections.typ",
        title: tr((
          en: [Critical sections]
        )),
      ),
      "internals/ceilings": (
        content: include "internals/ceilings.typ",
        title: tr((
          en: [Ceiling analysis]
        )),
      ),
      "internals/tasks": (
        content: include "internals/tasks.typ",
        title: tr((
          en: [Software tasks]
        )),
      ),
      "internals/timer-queue": (
        content: include "internals/timer-queue.typ",
        title: tr((
          en: [Timer queue]
        )),
      ),*/
    )
  ),
)

#book(
  tgt,
  sources,
  lang,
  languages,
  book_title: "Real-Time Interrupt-driven Concurrency",
  git: "https://github.com/rtic-rs/rtic",
  title_page: [
    #set align(center)
    #image("RTIC.svg", width: 18.8em)
    #text(size: 6em)[RTIC]

    #text(size: 20pt)[The hardware accelerated Rust RTOS]

    A concurrency framework for building real-time systems
  ]
)
