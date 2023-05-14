#import "../notebook-template.typ": notebook

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
