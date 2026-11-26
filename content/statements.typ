// Statements, proofs, problems and figures of the book. Formulas are
// numbered by the style (book-style.typ) through numbered-display below.
#import "numbering.typ": family-counter, label-prime, object-number, record
#import "main-defs.typ": new-paragraph, petit, spaced
#let sequence = [].func()
#let join-pieces(pieces) = sequence(
  pieces
    .map(it => if it.func() == sequence and not it.has("label") {
      it.children
    } else { (it,) })
    .flatten(),
)
#let keep-label(original, rebuilt) = {
  if original.has("label") [#rebuilt#original.label] else { rebuilt }
}

// A statement that opens with a list keeps its first item on the line of the
// head, «Теорема 3. 1) … », the other items below it: the first item becomes
// the opening paragraph and the list goes on from the second.
#let lift-first-item(body) = {
  let parts = if body.func() == sequence { body.children } else { (body,) }
  let skip = (it => it.func() in ([ ].func(), parbreak))
  let first = parts.position(it => not skip(it))
  if first == none { return body }
  let lead = parts.at(first)
  let (pattern, items, after, fields) = if lead.func() == enum.item {
    let end = first
    while (
      end < parts.len()
        and (parts.at(end).func() == enum.item or skip(parts.at(end)))
    ) { end += 1 }
    (
      auto,
      parts.slice(first, end).filter(it => it.func() == enum.item),
      parts.slice(end),
      (:),
    )
  } else if lead.func() == enum {
    let fields = lead.fields()
    let children = fields.remove("children")
    (
      fields.at("numbering", default: auto),
      children,
      parts.slice(first + 1),
      fields,
    )
  } else { return body }
  if items.len() == 0 { return body }
  let start = fields.at("start", default: 1)
  let label = context {
    let shown = if pattern == auto { enum.numbering } else { pattern }
    if type(shown) == str {
      text(style: "normal", numbering(shown, start))
    } else { numbering(shown, start) }
  }
  let rest = items.slice(1).map(it => it.body)
  let list = if rest.len() > 0 {
    let options = fields
    let _ = options.remove("start", default: none)
    enum(..options, start: start + 1, ..rest)
  }
  join-pieces((
    ..parts.slice(0, first),
    [#label #items.first().body],
    ..if list != none { (list,) } else { () },
    ..after,
  ))
}

// Put `head` at the start of the first paragraph of `body`.
#let prepend-heading(body, head) = {
  if (
    body.func() in (table, grid, figure, list, enum, terms)
      or (
        body.func() == math.equation and body.block
      )
  ) {
    // The head stays with the formula, table or list that follows it.
    block(sticky: true, par(head)) + body
  } else if body.func() == block {
    let fields = body.fields()
    let inner = fields.remove("body")
    block(prepend-heading(inner, head), ..fields)
  } else if body.func() == sequence and body.children.len() > 0 {
    let children = body.children
    let first = children.position(it => (
      it.func()
        not in (
          [ ].func(),
          parbreak,
        )
    ))
    if first == none { join-pieces((head, body)) } else {
      keep-label(body, join-pieces((
        ..children.slice(0, first),
        prepend-heading(children.at(first), head),
        ..children.slice(first + 1),
      )))
    }
  } else { head + body }
}

// The end of a proof, «□», at the end of its last line, a space at least after
// the last word; on a line of its own at the right if the line is full.
#let qed-sign = $square.stroked$
#let qed-mark = [ #box(width: 0pt)#h(1fr)#sym.wj#box(qed-sign)]

// Put `ending` after the last word or formula of `body`.
#let append-ending(body, ending) = {
  if body.func() == math.equation and body.block {
    // The mark stands at the right margin, on the line of the display, as
    // printed; the display keeps its label and its number.
    block(width: 100%, {
      pad(right: 1.5em, body)
      place(bottom + right, qed-sign)
    })
  } else if body.func() in (block, box) {
    let fields = body.fields()
    let inner = fields.remove("body")
    body.func()(append-ending(inner, ending), ..fields)
  } else if body.func() == sequence and body.children.len() > 0 {
    let children = body.children
    let last = children
      .rev()
      .position(it => it.func() not in ([ ].func(), parbreak))
    if last == none { join-pieces((body, ending)) } else {
      let index = children.len() - last - 1
      keep-label(body, join-pieces((
        ..children.slice(0, index),
        append-ending(children.at(index), ending),
        ..children.slice(index + 1),
      )))
    }
  } else { body + ending }
}

// A statement and a proof stand apart from the text with half a line above
// and below them, as printed; the space is weak and collapses with that of a
// neighbour. The head opens the first line at the margin, the next paragraphs
// of the statement are indented. The text after it without a blank line goes
// on from the margin, as after a display.
#let statement-space = 0.5em
#let statement-block(body, space: statement-space, after: auto) = context {
  let after = if after == auto { space } else { after }
  let source = repr(body)
  if source.contains("footnote") or source.contains("editorial-note") {
    // A line with a note mark goes to the next page together with its note
    // only in the flow of the page.
    block(width: 100%, above: par.spacing + space, below: 0pt)
    body
    block(width: 100%, above: par.spacing + after, below: 0pt)
  } else {
    block(
      width: 100%,
      breakable: true,
      above: par.spacing + space,
      below: par.spacing + after,
      body,
    )
  }
}

// An italic statement: also the words inside its formulas («где», «и») are
// italic, as printed; they take the text face.
#let italic-body(body) = {
  show math.equation: it => {
    show regex("\p{Cyrillic}+"): t => context if text.style == "italic" {
      text(font: "Libertinus Serif", style: "italic", t)
    } else { t }
    it
  }
  text(style: "italic", body)
}

// The label a reference names:  gives <def:name>. A variant
// names its base by a reference, so that the editor goes to the base.
#let reference-target(body) = {
  if body.func() == ref { return body.target }
  let found = body.children.find(it => it.func() == ref)
  assert(found != none, message: "prime: [@def:name] expected")
  found.target
}

// «Теорема 1.» in bold italic and the statement in italic, «Определение 2.»
// in bold italic and its text upright. `numbered: false` for the only
// statement of its kind in a section, «Лемма.»; `prime: [@def:name]` for a
// variant that carries the number of `name` with a prime, «Определение 2′»;
// `number:` a number given by the book where it breaks the series; `title`: a
// name after the number; `word`: the head in place of the kind.
#let statement(
  kind,
  family,
  body,
  numbered: true,
  number: none,
  prime: none,
  title: none,
  word: none,
  italic: true,
) = {
  let primed = if prime != none { (base: reference-target(prime), mark: "′") }
  let steps = numbered and number == none and primed == none
  if steps { family-counter(family).step() }
  let head = {
    if numbered {
      record(family, prime: primed, fixed: number)
    } else {
      [#metadata((kind: "numbered", family: family, number: none))<numbered>]
    }
    let shown = if word == none { kind } else { word }
    text(weight: "bold", style: "italic", {
      shown
      if numbered {
        [ ]
        context object-number(
          family,
          here(),
          prime: primed,
          fixed: number,
        ).last()
      }
      if title != none [ #text(weight: "regular", style: "normal")[(#title)]]
      [.]
    })
    [ ]
  }
  body = lift-first-item(body)
  if italic { body = italic-body(body) }
  statement-block(prepend-heading(body, head))
}
#let theorem(body, ..args) = statement("Теорема", "th", body, ..args)
#let lemma(body, ..args) = statement("Лемма", "lem", body, ..args)
#let proposition(body, ..args) = statement("Предложение", "prop", body, ..args)
#let assertion(body, ..args) = statement("Утверждение", "stmt", body, ..args)
#let corollary(body, ..args) = statement("Следствие", "cor", body, ..args)
#let definition(body, ..args) = statement(
  "Определение",
  "def",
  body,
  italic: false,
  ..args,
)

// A head in small capitals with a little letterspacing, «ПРИМЕР 7.»,
// «ЗАМЕЧАНИЕ.», «ЗАДАЧА.», and the text upright. The text face has no
// Cyrillic small capitals: the capitals after the first are set smaller.
#let caps-word(word) = {
  let letters = word.clusters()
  text(tracking: 0.05em)[#letters.first()#text(size: 0.8em, upper(
      letters.slice(1).join(),
    ))]
}
#let caps-statement(word, family, body, numbered: true, punct: ".") = {
  if numbered { family-counter(family).step() }
  let head = {
    if numbered { record(family) } else {
      [#metadata((kind: "numbered", family: family, number: none))<numbered>]
    }
    caps-word(word)
    if numbered {
      [ ]
      context family-counter(family).get().first()
    }
    [#punct ]
  }
  statement-block(prepend-heading(lift-first-item(body), head))
}
// «ПРИМЕР 7.», numbered in the section: `#example[…] <exm:name>`;
// `numbered: false` for the only example of a section.
#let example(body, numbered: true) = caps-statement(
  "Пример",
  "exm",
  body,
  numbered: numbered,
)
// «ЗАМЕЧАНИЕ.», unnumbered.
#let remark(body, numbered: false) = caps-statement(
  "Замечание",
  "rem",
  body,
  numbered: numbered,
)
// «ЗАДАЧА.» in the text of a section (not a problem of the list after it);
// `punct: ":"` where the book prints «ЗАДАЧА:».
#let task(body, numbered: false, punct: ".") = caps-statement(
  "Задача",
  "task",
  body,
  numbered: numbered,
  punct: punct,
)

// A run-in head in letterspaced type, «У п р а ж н е н и е.», «П о я с н е н
// и е.»: the word and its period, then the text of the paragraph.
// `punct`: the sign after the word where the book prints another,
// «В о п р о с:».
#let run-in(word, punct: ".") = [#spaced(word)#punct ]
// «У п р а ж н е н и е.» in the text of a section.
#let exercise(body, numbered: false, punct: ".") = {
  if numbered { family-counter("ex").step() }
  let head = {
    if numbered { record("ex") } else {
      [#metadata((kind: "numbered", family: "ex", number: none))<numbered>]
    }
    spaced[Упражнение]
    if numbered { context [ #family-counter("ex").get().first()] }
    [#punct ]
  }
  statement-block(prepend-heading(body, head))
}

// «Д о к а з а т е л ь с т в о.» and the proof, closed by «□». `of` names what
// is proved: `#proof(of: [теоремы~@th:name])[…]`; `head: none` for a proof the
// book opens without a head; `qed: false` where the book prints no end mark.
// A proof without a head either opens with the word in its sentence,
// «#spaced[Доказательство] леммы следует …», and stands apart like any
// proof, or goes on with a proof interrupted by a lemma: then its text runs
// on as ordinary paragraphs, as printed.
#let opens-with-head(body) = {
  let parts = if body.func() == sequence { body.children } else { (body,) }
  let first = parts.find(it => (
    it.func() not in ([ ].func(), parbreak, metadata)
  ))
  first != none and repr(first).contains("Доказательство")
}
#let proof(body, of: none, head: [Доказательство], qed: true) = {
  if qed { body = append-ending(body, qed-mark) }
  if head == none and not opens-with-head(body) { return body }
  let start = if head == none { [] } else {
    // Only the word is letterspaced: «Д о к а з а т е л ь с т в о
    // теоремы 1.»
    spaced(head)
    if of != none [ #of]
    [. ]
  }
  statement-block(prepend-heading(body, start), after: if qed {
    statement-space
  } else { 0pt })
}

// The problems after a section: «Задачи к § 1» bold and centred, the problems
// in small type, each «1.» at the indent of a paragraph:
// `#problems` then `#problem[…] <pr:name>` …; `@pr:name` prints «1».
#let problems = {
  family-counter("pr").update(0)
  context {
    let section = counter(heading).get().at(1, default: 0)
    let title = [Задачи к §~#section]
    block(
      width: 100%,
      above: 1.6em,
      below: 0.9em,
      sticky: true,
      {
        box(place(hide(heading(
          level: 3,
          numbering: none,
          outlined: false,
          bookmarked: true,
          title,
        ))))
        align(center, text(weight: "bold", size: 11pt, title))
      },
    )
  }
}
#let par-spacing = 11.8pt - 6.58pt
#let problem(body) = {
  family-counter("pr").step()
  // The number at the indent of a paragraph, the next lines at the margin.
  let head = {
    record("pr")
    h(1em)
    context [#family-counter("pr").get().first(). ]
  }
  petit(block(
    width: 100%,
    breakable: true,
    // The spacing of the paragraphs of the text, which the empty paragraph
    // of a blank line between two problems takes back.
    above: par-spacing,
    below: par-spacing,
    prepend-heading(body, head),
  ))
}

// A display with a label <eq:…> takes its number «(3)» at the right margin;
// <eq:name-prime> shares the number of <eq:name> with a prime.
#let numbered-display(it) = {
  let prime = label-prime(str(it.label))
  math.equation(
    block: true,
    numbering: _ => context {
      let own = if prime == none {
        str(family-counter("eq").get().first())
      } else {
        let base = query(selector(<numbered>).within(prime.base)).filter(
          it => it.value.family == "eq",
        )
        if base.len() == 1 {
          str(base.first().value.number.last()) + prime.mark
        } else { "?" }
      }
      text(style: "normal")[(#own)]
    },
    [#metadata((kind: "book-display"))#if prime == none {
        family-counter("eq").step()
      }#record("eq", prime: prime)#it.body],
  )
}

// A display with a symbolic number, «(A)», «(Г)»: a string or a formula;
// `@eq:…` prints the same: `#symbolic-display("A", $…$) <eq:euler>`.
#let symbolic-display(symbol, body) = math.equation(
  block: true,
  // The symbol of a system stands at the middle of its lines, as printed.
  number-align: end + horizon,
  numbering: _ => text(style: "normal")[(#symbol)],
  [#metadata((kind: "book-display"))#metadata((
      kind: "numbered",
      family: "eq",
      number: ("symbol",),
      symbol: symbol,
    ))<numbered>#body.body],
)

// Figures: `#fig(drawing) <fig:name>` with the caption «Рис. 3» under it, or
// `#fig(drawing, caption: [Сечение поверхности Бельтрами])` with words after
// the number. Figures float to the top or the bottom of a page near their
// place; `#figures[#fig(…) <fig:a> #fig(…) <fig:b>]` sets several side by
// side as one float. The number is recorded inside the figure, so references
// lead to the drawing itself. `number:` keeps a number the book prints out of
// its series.
#let figure-caption(number, caption) = {
  set par(first-line-indent: 0pt, justify: false)
  text(size: 8.5pt)[Рис.~#number#if caption != none [. #caption]]
}

// A float goes to the foot of the page that opens a chapter, never above the
// chapter's title or above a section heading on its page; in a row of figures
// (`#figures`) it does not float.
#let float-placement(need: 0pt) = {
  let current = figure.placement
  // The place of the float in the text, not where it is put.
  let anchors = query(selector(<float-anchor>).before(here()))
  let at = if anchors.len() > 0 { anchors.last().location().position() } else {
    here().position()
  }
  let after-heading = (
    query(heading.where(level: 1)).any(it => it.location().page() == at.page)
      or query(heading.where(level: 2)).any(it => {
        let position = it.location().position()
        position.page == at.page and position.y < at.y
      })
  )
  // A float that would not fit below its place goes to the top of the next
  // page, in order, rather than to its foot under the next section. The
  // floats placed before it on that page take their room first.
  let taken = anchors
    .slice(0, calc.max(anchors.len() - 1, 0))
    .filter(a => a.location().page() == at.page and a.value != none)
    .map(a => a.value)
    .sum(default: 0pt)
  let room = page.height - 19mm - at.y - taken
  if current == none { none } else if (
    after-heading and need.to-absolute() < room
  ) {
    bottom
  } else { current }
}
#let fig(body, caption: none, number: none) = context {
  // The room the float takes, recorded at its place in the text.
  let need = (measure(body).height + 3em).to-absolute()
  [#metadata(need)<float-anchor>]
  // In a row of figures (no placement of its own) a figure keeps its width.
  let width = if figure.placement == none { auto } else { 100% }
  context figure(
    placement: float-placement(need: need),
    {
      if number == none { family-counter("fig").step() }
      record("fig", fixed: number)
      block(width: width, align(center, body))
      v(0.5em, weak: true)
      // In a block of its own: the caption is not a paragraph of the text.
      block(width: width, align(center, context figure-caption(
        if number == none { family-counter("fig").get().first() } else {
          number
        },
        caption,
      )))
    },
    kind: "book-figure",
    supplement: none,
    numbering: none,
    outlined: false,
  )
}
#let figures(body, gap: 1.5em) = {
  let items = (
    if body.func() == sequence { body.children } else { (body,) }
  ).filter(it => it.func() not in ([ ].func(), parbreak, linebreak))
  context {
    let need = (measure(grid(..items)).height + 1.2em).to-absolute()
    [#metadata(need)<float-anchor>]
    context place(
      float-placement(need: need),
      float: true,
      clearance: 1.2em,
      {
        set figure(placement: none)
        // Each figure at its own width, the row centred, as in the book.
        block(width: 100%, align(center, grid(
          columns: (auto,) * items.len(),
          column-gutter: gap,
          align: center + bottom,
          ..items
        )))
      },
    )
  }
}
