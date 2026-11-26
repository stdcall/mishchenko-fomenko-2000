#import "numbering.typ": (
  chapter-of, family-counter, numbered-record, printed-number, record,
  record-number, reset-chapter, reset-section,
)

// `#source(n)`: the place where printed page n of the book begins; the page of
// the file is the printed page.
#let source(n) = [#metadata((
  kind: "source",
  file-page: n,
  printed-page: str(n),
))]

// Numbers are semibold in references, but never lighter than a bold heading
// around them, and never letterspaced with their head.
#let number-text(body) = context {
  let weight = text.weight
  let heavy = (
    weight in ("bold", "extrabold", "black")
      or (type(weight) == int and weight > 600)
  )
  text(
    weight: if heavy { weight } else { "semibold" },
    style: "normal",
    tracking: 0pt,
    body,
  )
}

// Keep a reference's invisible position with its first visible word.
// Descriptive references may wrap over several lines.
#let caption-link(body, destination) = {
  if type(body) == str { body = text(body) }
  if body.func() in ([ ].func(), linebreak, parbreak, h, v, metadata) {
    return body
  }
  if body.func() == text and body.has("text") {
    let visible = body.text.match(regex("\\S(?:[\\s\\S]*\\S)?"))
    if visible == none { return body }
    return [#body.text.slice(0, visible.start)#link(
        destination,
        body.text.slice(visible.start, visible.end),
      )#body.text.slice(visible.end)]
  }
  if body.func() == [].func() {
    return body.children.map(it => caption-link(it, destination)).join()
  }
  if body.func() in (emph, strong) {
    let fields = body.fields()
    let inner = fields.remove("body")
    return body.func()(caption-link(inner, destination), ..fields)
  }
  if body.func() == link { body } else { link(destination, body) }
}
#let anchor-caption(body, marker, destination) = {
  if body.func() in ([ ].func(), linebreak, parbreak, h, v, metadata) {
    return (false, body)
  }
  if body.func() == text and body.has("text") {
    let word = body.text.match(regex("\\S+"))
    if word == none { return (false, body) }
    return (
      true,
      [#body.text.slice(0, word.start)#box[
          #marker#link(destination, body.text.slice(word.start, word.end))
        ]#caption-link(body.text.slice(word.end), destination)],
    )
  }
  if body.func() == [].func() {
    let done = false
    let parts = ()
    for child in body.children {
      if done { parts.push(caption-link(child, destination)) } else {
        let (found, content) = anchor-caption(child, marker, destination)
        done = found
        parts.push(content)
      }
    }
    return (done, parts.join())
  }
  if body.func() in (emph, strong, link) {
    let fields = body.fields()
    let (found, content) = anchor-caption(
      fields.remove("body"),
      marker,
      destination,
    )
    return (found, body.func()(content, ..fields))
  }
  (true, box[#marker#link(destination, body)])
}

// A reference prints the own number of its target (numbering.typ): «7» for a
// theorem, a section or a figure, «(3)» for a formula, «[E1]» for a work of
// the editorial bibliography.
#let reference-body(
  it,
  caption,
  trace: true,
  bibliographic-mention: true,
) = context {
  let target = str(it.target)
  let prefix = target.split(":").first()
  // A citation takes its supplement as a place in the work, «[E1, гл. 2]»;
  // `[-]` prints the label alone.
  let locator = if prefix == "bib" and caption { it.supplement }
  let caption = caption and prefix != "bib"
  let record = if it.element != none { numbered-record(it.target) }
  let number = if prefix == "pg" and it.element != none {
    (counter(page).at(it.element.location()).first(),)
  } else if record != none { record-number(record) }
  // A descriptive reference may name an unnumbered statement.
  let pending = number == none and not (caption and record != none)
  let printed = if number == none { "?" } else { printed-number(number) }
  let symbol = if record != none { record.value.at("symbol", default: none) }
  let body = if caption { it.supplement } else if (
    prefix == "eq" and symbol != none
  ) {
    text(style: "normal", tracking: 0pt)[(#number-text(symbol))]
  } else if prefix == "eq" {
    text(style: "normal", tracking: 0pt)[(#number-text(printed))]
  } else if prefix == "bib" and locator == [-] {
    text(style: "normal", tracking: 0pt, number-text(printed))
  } else if prefix == "bib" {
    text(style: "normal", tracking: 0pt)[\[#number-text(printed)#if (
        locator != none
      ) [, #locator]\]]
  } else { number-text(printed) }
  if not trace { return body }
  let destination = if pending { none } else if (
    prefix == "pg" or it.element.func() == math.equation
  ) { it.element.location() } else { record.location() }
  let marker = {
    metadata((
      kind: "cross-reference",
      target: target,
      resolved: not pending,
      printed: printed,
      target-location: destination,
    ))
    if prefix == "bib" {
      [#metadata((
        kind: "bibliography-mention",
        target: target,
        bibliographic-mention: bibliographic-mention,
      ))<bibliography-mention>]
    }
  }
  if caption and not pending {
    return anchor-caption(body, marker, destination).last()
  }
  let anchored = [#marker#body]
  if pending { anchored } else { link(destination, anchored) }
}

#let reference-rules(body, trace: true, bibliographic-mention: true) = {
  show ref: it => {
    let caption = it.supplement not in (auto, none, [], [°], [′])
    let shown = reference-body(
      it,
      caption,
      trace: trace,
      bibliographic-mention: bibliographic-mention,
    )
    // A descriptive reference may wrap; a number, also a citation with its
    // place, stays whole with its marker.
    let citation = str(it.target).starts-with("bib:")
    if caption and not citation and it.supplement != [-] { shown } else {
      [#sym.wj#box(shown)]
    }
  }
  body
}

// A place that the text calls by its page («см. с. 94»): `#page-mark <pg:…>`
// at the place, `с.~@pg:…` in the text.
#let page-mark = metadata((kind: "page-mark"))

#let editorial-note-counter = counter("editorial-note")
#let ed-note(body) = {
  editorial-note-counter.step()
  [#metadata("editorial-note")]
  context {
    // «*1)» in the text and in the note, a space before the note's text.
    let mark = "*" + str(editorial-note-counter.get().first()) + ")"
    footnote(numbering: _ => mark)[#body~— _Прим.~ред._]
    counter(footnote).update(n => n - 1)
  }
}

// `short`: the title in the running head, where the book shortens it. It is
// kept in the supplement of the heading, which prints nowhere else.
#let running(title, short) = if short == none { title } else { short }
// A footnote of a title belongs to the printed title only: the heading, read
// by the bookmarks and the contents, takes the title without it.
#let without-notes(body) = {
  if type(body) != content { body } else if body.func() == footnote {
    []
  } else if body.func() == [].func() {
    body.children.map(without-notes).join()
  } else { body }
}

// «Глава 1 / ВВЕДЕНИЕ В ДИФФЕРЕНЦИАЛЬНУЮ ГЕОМЕТРИЮ» on a new page
// (book-style.typ). The text before § 1, an introduction of the chapter,
// counts its statements and formulas apart.
#let chapter(title, short: none) = {
  pagebreak(weak: true)
  reset-chapter()
  heading(level: 1, supplement: running(title, short), title)
}
// «§ 1. Криволинейные системы координат. Простейшие примеры», centred.
#let section(title, short: none) = {
  reset-section()
  heading(level: 2, supplement: running(title, short), title)
}

// A numbered point of a section, «1. Мотивировка.», run in bold at the head
// of its paragraph: `#subsection[Мотивировка] <ss:motivation> Рассмотрим …`.
// The head opens its paragraph at the margin; the heading that carries the
// number, the bookmark and the place of the point stands hidden at the start
// of the line.
#let subsection(title) = {
  // An empty block ends the paragraph before it; it adds a little space, as
  // printed.
  block(width: 100%, height: 0pt)
  box(place(hide(heading(
    level: 3,
    outlined: false,
    bookmarked: true,
    title,
  ))))
  context [#metadata((
    kind: "numbered",
    family: "heading",
    level: 3,
    number: (counter(heading).get().at(2),),
  ))<numbered>]
  context strong[#counter(heading).get().at(2). #title.]
  [ ]
}

// An empty paragraph keeps the chain of paragraphs: the next one is indented
// after a display, a list or a heading, too. It takes no room of its own. The
// style puts it at each blank line of the source (book-style.typ), so that a
// blank line after a display opens a new paragraph and text without one goes
// on with the sentence from the margin. The empty paragraph keeps the usual
// spacing, so that several of them in a row, around a figure or a mark that
// stands between paragraphs, still take no room.
#let new-paragraph = context {
  par(sym.zws)
  v(-par.spacing - measure(sym.zws).height)
}

// The small type of the preface and of the problems after a section.
#let petit-size = 8.5pt
#let petit-leading = 0.36em
#let petit(body) = {
  set text(size: petit-size)
  set par(leading: petit-leading, spacing: petit-leading)
  body
}

// The preface: a chapter-like opening without a number.
#let unnumbered-chapter(
  title,
  outlined: true,
  short: none,
) = {
  pagebreak(weak: true)
  heading(
    level: 1,
    numbering: none,
    outlined: outlined,
    supplement: running(title, short),
    title,
  )
}

// Bold letters: upright `bf(N)`, italic `bi(x)`.
#let bf(body) = math.upright(math.bold(body))
#let bi(body) = math.italic(math.bold(body))
// The Russian names of functions and operators, upright as in the book:
// `tg x`, `arctg y`, `sh t`, `grad f`, `Int Y`.
#let tg = math.op("tg")
#let ctg = math.op("ctg")
#let arctg = math.op("arctg")
#let arcctg = math.op("arcctg")
#let sh = math.op("sh")
#let ch = math.op("ch")
#let th = math.op("th")
#let cth = math.op("cth")
#let grad = math.op("grad")
#let rot = math.op("rot")
#let rk = math.op("rk")
#let rank = math.op("rank")
#let Int = math.op("Int")
#let Im = math.op("Im")
#let Ker = math.op("Ker")
#let Re = math.op("Re")
#let Iso = math.upright("Iso")
#let sgrad = math.op("sgrad")
#let vol = math.op("vol")
#let spur = math.op("spur")
#let supp = math.op("supp")
#let arcch = math.op("arcch")
#let div = math.op("div")
// The names of the classical groups, upright: `GL(n, RR)`, `SO(3)`.
#let GL = math.upright("GL")
#let SL = math.upright("SL")
#let SO = math.upright("SO")
#let SU = math.upright("SU")
#let Sp = math.upright("Sp")
// Delimiters that grow with their contents, where the book prints them so
// (the style keeps delimiters at text size, as TeX does): `grow((1/n + x))`.
// A comma inside the delimiters needs no escape: `grow((a, b))`.
#let grow(..body) = math.lr(body.pos().join($,$), size: 100%)
// An empty atom: a sign at the start of a row of a broken display stays binary,
// `& nil + d`.
#let nil = math.class("normal", box(width: 0pt))

// The letters of a list «а) … б) …»: `#enum(numbering: letter-item)[…][…]`.
#let letter-item(..n) = text(
  style: "normal",
  "абвгдежзиклмнопрстуфхцчшщэюя".clusters().at(n.pos().last() - 1) + ")",
)

// An upright insert in an italic statement.
#let roman(body) = text(style: "normal", body)

// A letterspaced word: «Д о к а з а т е л ь с т в о», «П о я с н е н и е».
#let spaced(body) = text(
  tracking: 0.2em,
  ligatures: false,
  hyphenate: false,
  body,
)

// The author of a preface at the right.
#let signature(name) = block(above: 0.8em, width: 100%, align(
  right,
  name,
))
