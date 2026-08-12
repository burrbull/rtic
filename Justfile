clean:
    rm -r book/en/book

build-en:
    typst compile book/typ/book.typ --root=. --input lang=en --input target=html book/en/book --features bundle,html -f bundle
    typst compile book/typ/book.typ --root=. --input lang=en --input target=pdf book/en/book/book_en.pdf

build: build-en

check-links:
    linkchecker book/en/book

format-html:
    for file in `find book/en/book -name "*.html"`; do \
        echo $file; \
        tidy -qim --alt-text "inlined image" --tidy-mark no --warn-proprietary-attributes no -w 120 --custom-tags blocklevel $file; \
    done
