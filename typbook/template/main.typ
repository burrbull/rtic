#import "config.typ": *
#import "@preview/typbook:0.1.0": book

#let sources = (
  "chapter1": (
    content: include "chapter1/index.typ",
    title: tr((
      en: [Chapter 1],
    )),
    sub: (
      "chapter1/section2": (
        content: include "chapter1/section2.typ",
        title: tr((
          en: [Section 2],
        )),
      ),
    ),
  ),
)

#book(
  tgt,
  sources,
  lang,
  languages,
  book_title: "Example Book",
)
