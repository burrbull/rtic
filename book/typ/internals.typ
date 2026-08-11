#import "config.typ": *

#h1((en: [Under the hood]
))

#strong[This is chapter is currently work in progress, it will re-appear
once it is more complete]

This section describes the internals of the RTIC framework at a
_high level_. Low level details like the parsing and code
generation done by the procedural macro (`#[app]`) will not be explained
here. The focus will be the analysis of the user specification and the
data structures used by the runtime.

We highly suggest that you read the embedonomicon section on
#link("https://github.com/rust-embedded/embedonomicon/pull/48")[concurrency]
before you dive into this material.
