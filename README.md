# Typst notebook

![license](https://img.shields.io/github/license/andreasKroepelin/typst-notebook)

This is a small template to write a notebook using [Typst](https://typst.app).

## Getting started
Put the file `notebook-template.typ` in the directory where you want to store
your notebook.

Then, create a Typst file as the following:
```typ
#import "notebook-template.typ": notebook

// not necessary, but I think the font works good for a notebook
#set text(font: "Inria Sans")

#show: notebook.with(
  title: [My cool notebook],
  author: [My name],
  tags: (
    tag-1: orange,
    tag-2: aqua,
  )
)

= Note 1

Something about @tag-1.
#lorem(10)

@tag-1 @tag-2


= Note 2

Refer to @note-1.
#lorem(10)

@tag-2


= Note 3

TODO do something

DONE something else

TODO do another thing
```

This produces the following document:
![screenshot](assets/screenshot.png)

