#let journal(
  tags: (:),
  title: [Journal],
  author: none,
  body
) = {
set page(width: 30em, height: auto, margin: 1em)
// set page(paper: "a5", flipped: true)
// set page(width: 50em, height: 20em, margin: 1em)
set text(font: "Inria Sans")
show math.equation: set text(font: "GFS Neohellenic Math")

let tag-occurrences = state("tag-occurences", (:))

let tag-box(tag) = box(
  width: auto, height: auto,
  fill: tag.color, stroke: none,
  inset: 1mm, baseline: 1mm, radius: 1mm,
  text(fill: if "text-color" in tag { tag.text-color } else { white }, tag.name)
)

show ref: it => {

  let refed-tag = tags.find(tag => it.target == label(tag.name))
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
pagebreak()

outline(depth: 1)
pagebreak()

[= Tags]
for tag in tags {
  box[
    #figure(kind: "tag", supplement: tag.name, numbering: (..n) => [], tag-box(tag))
    #label(tag.name)
  ]
  locate( loc => {
    let all-tag-occurrences = tag-occurrences.final(loc)
    if tag.name in all-tag-occurrences {
      let titles = all-tag-occurrences.at(tag.name).map( ref-loc => {
        let title = query(heading.where(level: 1).before(ref-loc), loc).last()
        link(ref-loc, title.body)
      })
      list(..titles)
    }
  })
}

show heading: it => {
  if it.level == 1 {
    pagebreak()
  }
  [
    #figure(kind: "entry", supplement: it.body, numbering: (..n) => [], [])
    #label(it.body.text.replace(" ", "-"))
  ]
  it
}

body
}
