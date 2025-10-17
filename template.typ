#let project(title: (), authors: (), body) = {
// Set the document's basic properties.
set document(author: authors, title: title)
set page(
  paper: "a4",
  margin: (left: 30mm, right: 30mm, top: 35mm, bottom: 30mm),
  numbering: "1 / 1",
  number-align: center,
  header: align(right)[
    #title
  ]
)

// for main text
set text(
    lang: "ja",  // 英語しか使わない文書では"en"とする（もしくは指定しない）
    size: 11pt,
    font: ("Times New Roman", "Yu Mincho"),  
    // font: (日本語文字を含まないフォント, 日本語文字を含むフォント),  となっている
)

// for headings
let heading_font(body) = {
    set text(font: ("Arial", "Yu Gothic"))  // weightの指定は反映されないらしい
    // font: (日本語文字を含まないフォント, 日本語文字を含むフォント),  となっている
    body
}
show heading: heading_font  // heading_fontを適用する

// タイトル周り
align(center)[
  #block(text(weight: 700, 1.75em, title))
]

set heading(numbering: (..args) => {
  let nums = args.pos() // 引数の位置引数を`array`として取得
  if nums.len() == 1 { // 階層総数が1しかない、即ち最高階層
    return numbering("1.", ..nums)
  } else {
    return numbering("1.1", ..nums)
  }
})

// 筆者の情報
pad(
  top: 0.5em,
  bottom: 0.5em,
  x: 2em,
  grid(
    columns: (1fr) * calc.min(3, authors.len()),
    gutter: 1em,
    ..authors.map(author => align(center, author)),
  ),
)

// メイン部分の設定
set par(justify: true, leading: 0.75em,first-line-indent: 1em,)
show: columns.with(1, gutter: 1.3em) // カラム数をいじりたいときはここを

// 箇条書きと別行立て数式の設定
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
      ..counter(eq).at(el.location())
    ) 
    [式] 
  } else {

      it
  }
}
show math.equation: set text(font:"Cambria Math")

show link: set text(fill: blue)

set footnote(
  numbering: (..args) => {
    "*" + str(args.pos().at(0))
  },
)

// 空白に関する設定
show regex("[\\P{latin}&&[[:^ascii:]]][\\p{latin}[[:ascii:]]]|[\\p{latin}[[:ascii:]]][\\P{latin}&&[[:^ascii:]]]") : it => {
    let a = it.text.match(regex("(.)(.)"))
    a.captures.at(0)+h(0.25em)+a.captures.at(1)
}

body
}
