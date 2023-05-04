#let journal(
  tags: (:),
  title: [Journal],
  author: none,
  page-width: 50em,
  body
) = {
set page(width: page-width, height: auto, margin: 3em)

for tag in tags.keys() {
  let curr-value = tags.at(tag)
  if type(curr-value) == "color" {
    tags.insert(tag, (color: curr-value, text-color: white))
  }
}
let named-tags = tags.pairs().map( ((name, colors)) => (name: name, ..colors) )

let tag-occurrences = state("tag-occurences", (:))
let heading-positions = state("heading-positions", ())

let tag-box(tag) = box(
  width: auto, height: auto,
  fill: tag.color, stroke: none,
  inset: 1mm, baseline: 1mm, radius: 1mm,
  text(fill: tag.text-color, tag.name)
)

show ref: it => {

  let refed-tag = named-tags.find(tag => it.target == label(tag.name))
  if refed-tag == none {
    { sym.arrow.tr; it }
  } else {
    let display = refed-tag
    display.name = it
    tag-box(display)

    locate( loc => {
      tag-occurrences.update( to => {
        if refed-tag.name in to {
          to.at(refed-tag.name).push(loc)
        } else {
          to.insert(refed-tag.name, (loc,))
        }
        to
      })
    })
  }
}

block(width: 100%, height: 5em, align(center + horizon)[
  #text(size: 1.5em, strong(title))
  #linebreak()
  #author
])

[= Entries]
locate( loc => {
  let all-headings = heading-positions.final(loc)
  grid(
    columns: (1fr, 1fr, 1fr), gutter: 1em,
    ..all-headings.map( h => link(h.last(), sym.arrow.tr + h.first()) )
  )
})

[= Tags]
{
let grid-children = ()
for tag-name in tags.keys().sorted() {
  let tag = tags.at(tag-name)
  let named-tag = (name: tag-name, ..tag)
  let def = box(baseline: 1mm)[
    #figure(kind: "tag", supplement: tag-name, numbering: (..n) => [], tag-box(named-tag))
    #label(tag-name)
  ]
  let details = locate( loc => {
    let all-tag-occurrences = tag-occurrences.final(loc)
    if tag-name in all-tag-occurrences {
      let titles = all-tag-occurrences.at(tag-name).map( ref-loc => {
        let title = query(heading.where(level: 1).before(ref-loc), loc).last()
        link(ref-loc, sym.arrow.tr + title.body)
      })
      titles.join(h(1em))
    }
  })
  grid-children.push(def)
  grid-children.push(details)
}

grid(
  columns: (auto, 1fr),
  gutter: 1em,
  ..grid-children
)
}

show heading: it => {
  let label-name = it.body.text.replace(" ", "-")
  locate( loc => {
    heading-positions.update( hp => hp + ( (it.body, loc), ) )
  })
  [
    #figure(kind: "entry", supplement: it.body, numbering: (..n) => [], [])
    #label(label-name)
  ]
  block[
    #it.body
    #text(size: .5em, raw(block: false, lang: "typ", "@" + label-name))
  ]
}

show link: it => {
  if type(it.dest) == "string" {
    text(fill: blue, sym.triangle.stroked.tr + [ ] + it)
  } else {
    it
  }
}

body
}
