#let notebook(
  tags: (:),
  title: [Notebook],
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
let todos = state("todos", ())

let tag-box(tag) = box(
  width: auto, height: auto,
  fill: tag.color, stroke: none,
  inset: 1mm, baseline: 1mm, radius: 1mm,
  text(fill: tag.text-color, tag.name)
)

let sections-with-count(locs, display-count: (_ => [])) = {
  let locs-and-titles = locs.map( l => {
    let title = query(heading.where(level: 1).before(l), l).last()
    (l, title)
  })

  let deduped = ()
  for (l, title) in locs-and-titles {
    if deduped.len() == 0 {
      deduped.push((loc: l, title: title, count: 1))
      continue
    }

    let last = deduped.pop()
    if last.title != title {
      deduped.push(last)
      deduped.push((loc: l, title: title, count: 1))
    } else {
      last.count += 1
      deduped.push(last)
    }
  }

  deduped.map( it => {
    link(it.loc, sym.arrow.tr + it.title.body + display-count(it.count))
  }).join(h(1em))
}

show ref: it => {

  let refed-tag = named-tags.find(tag => it.target == label(tag.name))
  if refed-tag == none {
    underline({ sym.arrow.tr; it })
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

[= Open TODOs]
locate( loc => {
  sections-with-count(
    todos.final(loc),
    display-count: c => text(fill: red, [ (#c)])
  )
})

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
      sections-with-count(all-tag-occurrences.at(tag-name))
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
  let content-text(c) = if type(c) == "string" {
    c
  } else if c.has("text") {
    content-text(c.text)
  } else if c.has("children") {
    c.children.map(content-text).join(" ")
  } else {
    ""
  }

  let label-name = content-text(it.body).codepoints().filter( cp => {
    cp.match(regex("[[:alnum:]]| ")) != none
  }).map( cp => {
    lower(if cp == " " { "-" } else { cp })
  }).fold( (), (cps, cp) => {
    if cp == "-" and cps.len() > 0 and cps.last() == "-" {
      cps
    } else {
      cps + (cp,)
    }
  }).join().trim("-")

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

show "TODO": it => {
  locate( loc => {
    todos.update(ts => ts + (loc,))
  })
  text(fill: red, size: 1em, weight: "bold", smallcaps(it))
}
show "DONE": it => text(fill: green, size: 1em, weight: "bold", smallcaps(it))

body
}
