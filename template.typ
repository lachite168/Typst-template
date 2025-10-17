// for table
#import "@preview/pillar:0.3.3"

#let project(title: (), subtitle: none, authors: (), body) = {
  // Set the document's basic properties.
  set document(author: authors, title: title)
  set page(
    paper: "a4",
    margin: (left: 30mm, right: 30mm, top: 35mm, bottom: 30mm),
    numbering: "1 / 1",
    number-align: center,
    header: align(right)[
      #title
    ],
  )
  
  // for main text
  set text(
    lang: "ja",
    size: 11pt,
    font: ("Times New Roman", "Yu Mincho"),
  )
  
  // for headings
  let heading_font(body) = {
    set text(font: ("Arial", "Yu Gothic")) // weightの指定は反映されないらしい
    body
  }
  show heading: heading_font
  
  // for title
  align(center)[
    #block(text(weight: 700, 1.75em, title))
  ]
  
  if subtitle != none {
    align(center)[
      #block(text(weight: 700, 1.25em, subtitle))
    ]
  }
  
  set heading(numbering: (..args) => {
    let nums = args.pos()
    if nums.len() == 1 {
      return numbering("1.", ..nums)
    } else {
      return numbering("1.1", ..nums)
    }
  })
  
  // for authors
  pad(
    top: 0.5em,
    bottom: 0.5em,
    x: 2em,
    grid(
      columns: 1fr * calc.min(3, authors.len()),
      gutter: 1em,
      ..authors.map(author => align(right, author)),
    ),
  )
  
  // for main content
  set par(justify: true, leading: 0.75em /*first-line-indent: 1em,*/) // because of bugs
  show: columns.with(1, gutter: 1.3em)
  
  // for enum and mathemaical formula
  set list(indent: 0.5em)
  set enum(numbering: "(1)")
  set math.equation(numbering: "(1)")
  show ref: it => {
    let eq = math.equation
    let el = it.element
    if el != none and el.func() == eq {
      // Override equation references.
      numbering(
        el.numbering,
        ..counter(eq).at(el.location()),
      )
      [式]
    } else {
      it
    }
  }
  show math.equation: set text(font: "Cambria Math")
  
  show link: set text(fill: blue)
  
  // for table
  set table(inset: (x: 0.8em, y: 0.6em), stroke: none)
  set table.hline(stroke: 0.6pt)
  set table.vline(stroke: 0.6pt)
  show figure.where(
    kind: table
  ): set figure.caption(position: top)
  
  // for footnote
  set footnote(
    numbering: (..args) => {
      "*" + str(args.pos().at(0))
    },
  )
  
  // for spaceing
  show regex(
    "[\\P{latin}&&[[:^ascii:]]][\\p{latin}[[:ascii:]]]|[\\p{latin}[[:ascii:]]][\\P{latin}&&[[:^ascii:]]]",
  ): it => {
    let a = it.text.match(regex("(.)(.)"))
    a.captures.at(0) + h(0.25em) + a.captures.at(1)
  }
  
  body
}

// for table
#let tbl(header, cells, footer: none, cols: none) = {
  if footer == none {
    if cols == none {
      table(
        columns: header.len(),
        table.hline(),
        table.header(..header.flatten()),
        table.hline(),
        ..cells,
        table.hline(),
      )
    } else {
      table(
        ..pillar.cols(cols),
        columns: header.len(),
        table.hline(),
        table.header(..header.flatten()),
        table.hline(),
        ..cells,
        table.hline(),
      )
    }
  } else {
    if cols == none {
      table(
        columns: header.len(),
        table.hline(),
        table.header(..header.flatten()),
        table.hline(),
        ..cells,
        table.hline(),
        table.footer(..footer.flatten()),
        table.hline()
      )
    } else {
      table(
        ..pillar.cols(cols),
        columns: header.len(),
        table.hline(),
        table.header(..header.flatten()),
        table.hline(),
        ..cells,
        table.hline(),
        table.footer(..footer.flatten()),
        table.hline()
      )
    }
  }
}

#let ftbl(caption, ..body) = {
  figure(
    caption: caption,
    tbl(
      ..body
    ),
  )
}

// for image
#let img(path, width: 70%) = {
  image(
    pass,
    width: width,
  )
}

#let fimg(caption, ..body) = {
  figure(
    caption: caption,
    ..body
  )
}
