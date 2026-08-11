# typbook

A Typst package for generating `mdBook` like books.

Project goals:
- Multilingual books
- Generating both `html` and `pdf`

Similar projects:
- [shiroa](https://typst.app/universe/package/shiroa)
- [haita](https://typst.app/universe/package/haita)

## Usage

This library requires several compilations for different languages and targets.

```typst
#import "@preview/typbook:0.1.0": book
```

### `book(tgt, sources, ...)`

**Parameters:**

- `tgt` (string) — One of `html` or `pdf`
- `sources` (dict) — Chapter tree
- `lang` (string) — Language for current compilation
- `languages`: (dict) — All avaliable languages of the book,
- `book_title`: (string, default: `The Book`) — Title of the book,
- `default_lang`: (string, default: "en") — Root language of the book,
  generated `html` files for other languages can be found in subdirectories

### Compilation

Compile HTML:
```console
typst compile main.typ --input lang=en --input target=html book --features bundle,html -f bundle
```

Then compile PDF:
```console
typst compile main.typ --input lang=en --input target=pdf book/book_en.pdf
```

## License

[MPL-2.0](LICENSE)
