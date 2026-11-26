#import "main-defs.typ": (
  petit, petit-leading, petit-size, reference-rules, spaced,
)
#import "statements.typ": new-paragraph, numbered-display, prepend-heading

// The page of the book, 60×90/16, 145×215 mm. The type area is 112.4 mm
// wide (25 ciceros) with 40 lines of 10 pt on a 11.8 pt baseline under the
// running head, as printed. The text is set in Libertinus Serif, the
// formulas in New Computer Modern Math: the book has a roman of the Times
// kind with the mathematics of TeX.
#let page-width = 145mm
#let page-height = 215mm
#let body-margin = (left: 16.3mm, right: 16.3mm, top: 24mm, bottom: 25.5mm)
#let text-font = "Libertinus Serif"
#let head-font = "Liberation Sans"
#let math-font = "New Computer Modern Math"
#let baseline-skip = 11.8pt
// Libertinus Serif has a cap height of 0.658 em: the gap between the lines
// gives the baseline skip.
#let line-gap = baseline-skip - 6.58pt
#let paragraph-indent = 1em

// Capitals, a hyphen between letters not broken.
#let upper-word(value) = upper(value).replace(
  regex("(\p{L})-(\p{L})"),
  m => m.captures.first() + "\u{2011}" + m.captures.last(),
)
// A title in capitals except its formulas.
#let upper-text(body) = {
  if type(body) == str { upper-word(body) } else if (
    body.func() == math.equation
  ) {
    body
  } else if body.func() == [].func() {
    body.children.map(upper-text).join()
  } else if body.func() == text { upper-word(body.text) } else if (
    body.func() in (emph, strong)
  ) {
    body.func()(upper-text(body.body))
  } else { body }
}

// A title the book breaks into lines stands in one line in the running head
// and the contents.
#let one-line(body) = {
  if type(body) != content { body } else if (
    body.func() == linebreak
  ) [ ] else if (
    body.func() == [].func()
  ) { body.children.map(one-line).join() } else { body }
}

// The plain text of a title, or none if it holds more than words.
#let title-text(body) = {
  if type(body) == str { body } else if body.has("text") { body.text } else if (
    body == [ ]
  ) { " " } else if body.func() == [].func() {
    let parts = body.children.map(title-text)
    if parts.all(part => part != none) { parts.join() }
  }
}
// A centred title too long for one line falls into two lines of nearly
// equal length, as printed: «§ 1. Криволинейные системы / координат.
// Простейшие примеры». A title with a formula, or one that needs three
// lines, is broken by the paragraph.
#let balanced-title(lead, title, width) = context {
  let full = [#lead#title]
  let plain = title-text(title)
  if plain == none or measure(full).width <= width { return full }
  let words = plain.split(" ")
  let best = none
  for k in range(1, words.len()) {
    // A preposition or a conjunction does not end a line: «в», «и», «на».
    if words.at(k - 1).clusters().len() <= 2 { continue }
    let first = measure([#lead#words.slice(0, k).join(" ")]).width
    let second = measure(words.slice(k).join(" ")).width
    let widest = calc.max(first, second)
    if widest <= width and (best == none or widest < best.at(0)) {
      best = (widest, k)
    }
  }
  if best == none { return full }
  let k = best.at(1)
  [#lead#words.slice(0, k).join(" ")#linebreak()#words.slice(k).join(" ")]
}

// A page that opens a chapter or the preface has neither running head nor
// folio.
#let opening-page() = {
  query(heading.where(level: 1))
    .map(it => it.location().page())
    .contains(here().page())
}

// The title in the running head: its short form if it has one.
#let running-title(it) = {
  if it.supplement in (auto, none) { it.body } else { it.supplement }
}

// The running head over a double rule, the folio outside: even pages «8
// Гл. 1. ВВЕДЕНИЕ В ДИФФЕРЕНЦИАЛЬНУЮ ГЕОМЕТРИЮ», odd pages «§ 1.
// КРИВОЛИНЕЙНЫЕ СИСТЕМЫ КООРДИНАТ 7», the last section begun on the page or
// before it; before § 1 of a chapter the chapter on both. The preface gives
// its title, «Предисловие 5».
#let running-header = context {
  if opening-page() { return }
  let chapters = query(heading.where(level: 1).before(here()))
  if chapters.len() == 0 { return }
  let chapter = chapters.last()
  let even = calc.even(counter(page).get().first())
  let chapter-head = {
    let number = counter(heading).at(chapter.location()).first()
    [Гл.~#number. #upper-text(one-line(running-title(chapter)))]
  }
  let middle = if chapter.numbering == none {
    one-line(running-title(chapter))
  } else if even { chapter-head } else {
    let here-page = here().page()
    let sections = query(heading.where(level: 2).after(chapter.location()))
    let begun = sections.filter(it => it.location().page() <= here-page)
    if begun.len() == 0 { chapter-head } else {
      let number = counter(heading).at(begun.last().location()).at(1)
      [§~#number. #upper-text(one-line(running-title(begun.last())))]
    }
  }
  let folio = text(font: text-font, size: 10pt, counter(page).display())
  set par(first-line-indent: 0pt, justify: false)
  set text(font: head-font, size: 7.5pt)
  block(
    width: 100%,
    inset: (bottom: 2.5pt),
    {
      grid(
        columns: (auto, 1fr, auto),
        align: (left + bottom, center + bottom, right + bottom),
        if even { folio }, middle, if not even { folio },
      )
      v(2pt)
      line(length: 100%, stroke: 0.4pt)
      v(-0.6pt)
      line(length: 100%, stroke: 0.4pt)
    },
  )
}

// A formula in the line stands in text style; a line is opened up only as far
// as a tall formula needs, as in TeX: it may reach a little into the gap above
// and below, where the next line has its descenders and capitals. Only formulas
// with a tall construction are measured.
#let tall-marks = (
  "frac(",
  "binom(",
  "∑",
  "∏",
  "∫",
  "∮",
  "⋃",
  "⋂",
  "limits",
  "lr(",
  "mat(",
  "vec(",
  "cases(",
  "sqrt(",
  "root(",
  // An arrow or a bar over a letter would touch the descenders of the line
  // above.
  "overline(",
  "arrow(",
  "accent(",
  "t: attach(",
)
#let inline-equation-spaced(it) = {
  let source = repr(it.body)
  if tall-marks.any(mark => source.contains(mark)) {
    context {
      // The parts of the formula above and below the baseline, each
      // measured in a line beside a strut that stands wholly above or wholly
      // below the baseline.
      let strut = 100pt
      let part(shift) = (
        measure({
          set text(top-edge: "bounds", bottom-edge: "bounds")
          box(height: strut, baseline: shift)
          it
        }).height
          - strut
      )
      let below = part(0%)
      let above = part(100%)
      // The formula reaches into the space between the lines as far as the
      // text does: above the capital height no higher than a bracket, below
      // the baseline no lower than a descender.
      // Integrals, sums and products carry their limits above and below
      // (the rule of text-math-rules), as does `limits(…)`.
      let limited = ("limits", "∫", "∑", "∏").any(mark => source.contains(mark))
      let hang = if limited { 0.1em } else { 0.25em }
      text(
        top-edge: calc.max(above, 0.75em.to-absolute()) - 0.067em,
        bottom-edge: -calc.max(below, hang.to-absolute()) + hang,
        it,
      )
    }
  } else { it }
}
// A short formula stays whole in its line, «$n + 1$»: TeX discourages a break
// after a relation or an operation by a penalty, Typst breaks there as
// readily as between words.
#let short-formula = 6em
#let inline-equation(it) = context {
  let shown = inline-equation-spaced(it)
  if measure(it).width < short-formula.to-absolute() { box(shown) } else {
    shown
  }
}

// Rules of the text and of formulas, shared by the book and the
// corrections sheet.
#let text-math-rules(body) = {
  // The blank line of the source opens a paragraph with its indent, also
  // after a display, a list or a heading; text without a blank line after a
  // display goes on with the sentence from the margin.
  show parbreak: it => {
    new-paragraph
    it
  }
  // Abbreviations and initials stand with a thin space and do not break
  // inside: «т. е.», «А. Н. Колмогоров».
  show regex("\b\p{L}{1,2}\.(?:\u{a0}\p{L}{1,2}\.)+"): it => box(
    it.text.replace("\u{a0}", "\u{2009}"),
  )
  // A text hyphen following inline math belongs to the preceding symbol.
  show regex("-"): it => [#text("\u{2060}")#it]
  // A short ending stays with the formula before it: «$n$-мерный» breaks
  // after the hyphen only, «$j$-й» not at all. Defined after the rule for
  // every hyphen, so that it applies first.
  show regex("-\p{Cyrillic}{1,3}\b"): it => [#sym.wj#box(it.text)]
  show regex("^-"): [#sym.wj#"-"#sym.wj]
  // No line begins with a dash: «$X$~— метрическое пространство».
  show "—": it => [#sym.wj#it]
  show "–": it => [#sym.wj#it]
  // Words inside formulas take the text face; the math font has no
  // Cyrillic.
  show math.equation: set text(font: math-font, weight: "regular")
  // A formula in bold text is bold too.
  show strong: it => {
    show math.equation: set text(weight: "bold")
    it
  }
  // As in TeX: delimiters keep their size around indices and fractions unless
  // a formula asks for growing ones, `grow((…))`.
  set math.lr(size: 1em)
  show math.equation: it => {
    // The colon of «f: A -> B» is punctuation.
    show ":": math.class("punctuation", ":")
    show regex("\p{Cyrillic}+"): word => text(font: text-font, word)
    // The limits of integrals and sums stand above and below them, also in
    // the line, as printed.
    show "∫": math.limits
    show "∑": math.limits
    show "∏": math.limits
    // ≥ and ≤ are slanted, as printed.
    // ∇ with its index is a letter of the formula, «∇_k ∇_l − ∇_l ∇_k»:
    // Typst would take it for an operator and lose the space of the minus.
    show "∇": math.class("normal", sym.nabla)
    show "≥": sym.gt.eq.slant
    show "≤": sym.lt.eq.slant
    it
  }
  show math.equation.where(block: false): inline-equation
  // The entries of a matrix stand at the size of a display, fractions
  // included, as printed; the rebuilt matrix carries a label so that the
  // rule does not apply to it again.
  show math.mat: it => {
    if it.at("label", default: none) == <displayed-mat> { return it }
    let fields = it.fields()
    let rows = fields.remove("rows")
    let _ = fields.remove("label", default: none)
    // A partition line keeps the stroke of the style when it has none of
    // its own: the constructor takes no `auto`.
    let augment = fields.at("augment", default: none)
    if (
      type(augment) == dictionary
        and augment.at("stroke", default: none) == auto
    ) {
      let _ = augment.remove("stroke")
      fields.insert("augment", augment)
    }
    [#math.mat(..fields, ..rows.map(row => row.map(
      math.display,
    )))<displayed-mat>]
  }
  body
}

// The two-line title of a chapter on a sunk page: «Глава 1» and under it
// the title in bold capitals, centred.
#let chapter-sink = 34mm

#let book-style(body) = {
  set page(
    width: page-width,
    height: page-height,
    margin: body-margin,
    numbering: "1",
    header: running-header,
    header-ascent: 3.5mm,
    footer: none,
  )
  set text(font: text-font, size: 10pt, lang: "ru")
  set par(
    justify: true,
    leading: line-gap,
    spacing: line-gap,
    first-line-indent: paragraph-indent,
  )
  // The bookmarks carry the printed numbers: «Глава 1. Введение …», «§ 1.
  // Криволинейные системы …», «1. Мотивировка».
  set heading(numbering: (..numbers) => {
    let n = numbers.pos()
    if n.len() == 1 { "Глава " + str(n.first()) + "." } else if n.len() == 2 {
      "§ " + str(n.last()) + "."
    } else { str(n.last()) + "." }
  })
  // The editorial notes «*1)» at the foot of the page, as small type.
  set footnote.entry(separator: line(length: 25%, stroke: 0.4pt))
  show footnote.entry: it => {
    let note = it.note
    let mark = numbering(
      note.numbering,
      ..counter(footnote).at(note.location()),
    )
    set text(size: petit-size)
    set par(leading: petit-leading, first-line-indent: 1em)
    // The build compares the page of each entry with the page of its mark. A
    // note is not split across pages: Typst may begin a split note on the page
    // before the line of its mark (typst#5314).
    block(width: 100%, breakable: false)[#metadata((
        kind: "footnote-entry",
      ))#link(note.location(), mark)#h(0.3em)#note.body]
  }
  show heading: set text(weight: "bold")
  // A chapter opens a page, sunk: «Глава 1» and its title in bold capitals,
  // centred. The preface: its title at the head of the page.
  show heading.where(level: 1): it => {
    let numbered = it.numbering != none
    if numbered {
      context [#metadata((
        kind: "numbered",
        family: "heading",
        level: 1,
        number: (counter(heading).at(it.location()).first(),),
      ))<numbered>]
    }
    set par(first-line-indent: 0pt, justify: false, leading: 0.5em)
    if numbered {
      block(width: 100%, above: 0pt, below: 15mm, sticky: true, {
        v(chapter-sink)
        align(center, text(size: 11pt, {
          [Глава ]
          context counter(heading).at(it.location()).first()
        }))
        v(4mm)
        align(center, text(size: 11pt, upper-text(it.body)))
      })
    } else {
      // The title stands where the running head of the page would be, as
      // printed: the head band of an opening page is empty.
      v(-7mm)
      block(width: 100%, above: 0pt, below: 6mm, sticky: true, align(
        center,
        text(size: 11pt, it.body),
      ))
    }
  }
  // «§ 1. Криволинейные системы координат. Простейшие примеры» in bold,
  // centred, a long title in lines of nearly equal length.
  show heading.where(level: 2): it => {
    context [#metadata((
      kind: "numbered",
      family: "heading",
      level: 2,
      number: (counter(heading).at(it.location()).at(1),),
    ))<numbered>]
    set par(first-line-indent: 0pt, justify: false, leading: 0.45em)
    block(width: 100%, above: 2.2em, below: 1.3em, sticky: true, {
      set text(size: 11pt)
      let number = context counter(heading).at(it.location()).at(1)
      align(center, balanced-title(
        [§~#number. ],
        it.body,
        0.82 * (page-width - body-margin.left - body-margin.right),
      ))
    })
  }
  // The numbered points and the problems' heads are set by their helpers
  // (main-defs.typ, statements.typ); their headings stand hidden.
  show heading.where(level: 3): it => it.body
  show: text-math-rules
  // Emphasis is italic type, not the toggle of emph.
  show emph: it => text(style: "italic", it.body)
  show math.equation.where(block: true): set block(above: 0.7em, below: 0.7em)
  // A display of many lines may break across pages; one of up to four lines,
  // and a numbered one, stays whole.
  show math.equation.where(block: true, numbering: none): it => {
    let rows = if it.body.func() == [].func() {
      it.body.children.filter(child => child.func() == linebreak).len() + 1
    } else { 1 }
    if rows > 4 {
      set block(breakable: true)
      it
    } else { it }
  }
  // Formula numbers «(3)» at the right margin, on the last row of the
  // formula, as printed.
  set math.equation(number-align: end + bottom)
  show math.equation.where(block: true): it => {
    let parts = if it.body.has("children") { it.body.children } else {
      (it.body,)
    }
    let done = parts.any(part => (
      part.func() == metadata
        and part.value.at("kind", default: none) == "book-display"
    ))
    if done or not (it.has("label") and str(it.label).starts-with("eq:")) {
      it
    } else { numbered-display(it) }
  }
  // Lists «1) … 2) …» as printed: upright labels also inside italic
  // statements, the items at the paragraph indent; «а) … б) …» with
  // `numbering: letter-item`.
  set enum(
    indent: paragraph-indent,
    body-indent: 0.5em,
    numbering: (..n) => text(style: "normal", numbering("1)", ..n)),
  )
  set list(indent: paragraph-indent)
  // The items of a list are paragraphs led by their numbers at the indent,
  // their next lines at the margin, as printed: «1) Длина кривой …».
  show enum: it => {
    let pattern = it.numbering
    let number = if it.start == auto { 1 } else { it.start }
    for item in it.children {
      let given = item.at("number", default: auto)
      if given != auto and given != none { number = given }
      let label = text(style: "normal", if type(pattern) == str {
        numbering(pattern, number)
      } else { pattern(number) })
      block(
        width: 100%,
        above: par.spacing,
        below: par.spacing,
        prepend-heading(item.body, [#h(paragraph-indent)#label ]),
      )
      number += 1
    }
  }
  // Figures float near their place (statements.typ).
  set figure(placement: auto, gap: 0.5em)
  show figure: set block(above: 1.2em, below: 1.2em)
  // A table stands centred between paragraphs.
  set table(stroke: 0.4pt, inset: (x: 0.5em, y: 0.35em))
  show table: it => block(
    width: 100%,
    above: 1em,
    below: 1em,
    breakable: false,
    align(center, it),
  )
  show: reference-rules
  body
}

// The contents as printed: «Предисловие . . . 4», «Г л а в а 1. Введение в
// дифференциальную геометрию . . . 6» with the title in bold, the sections
// «§ 1. Криволинейные системы координат . . . 6» under it. Every entry links
// to its place.
#let contents-line(number, number-width, title, location) = {
  let page = counter(page).at(location).first()
  set par(first-line-indent: 0pt, justify: false, hanging-indent: 0pt)
  grid(
    columns: (number-width, 1fr, 2.4em),
    if number != none { link(location, number) },
    link(location, [#title#h(0.3em)#box(width: 1fr, repeat(gap: 0.3em)[.])]),
    align(right + bottom, link(location, str(page))),
  )
}
#let book-contents = context {
  let headings = query(heading).filter(it => it.outlined)
  set text(size: 9pt)
  set par(leading: 0.35em)
  for it in headings {
    let location = it.location()
    let numbers = counter(heading).at(location)
    if it.level == 1 and it.numbering == none {
      block(
        width: 100%,
        above: 0.35em,
        below: 0.9em,
        contents-line(none, 0pt, one-line(it.body), location),
      )
    } else if it.level == 1 {
      block(
        width: 100%,
        above: 0.9em,
        below: 0.45em,
        sticky: true,
        contents-line(
          [#spaced[Глава] #numbers.first().],
          6.2em,
          text(weight: "bold", one-line(it.body)),
          location,
        ),
      )
    } else if it.level == 2 {
      block(width: 100%, above: 0.25em, below: 0.2em, pad(
        left: 6.2em,
        contents-line(
          [§~#numbers.at(1).],
          2em,
          one-line(it.body),
          location,
        ),
      ))
    }
  }
}
