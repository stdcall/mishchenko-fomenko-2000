// The front cover: dark red cloth blocked in gold. At the top the authors; the
// word «КУРС» in large outlined capitals; the rest of the title in condensed
// capitals; a line drawing by A. T. Fomenko, a figure on a slanted plane with
// the letter χ; at the foot the publisher's mark «Факториал» in script.
// Places are given in the coordinates of a 547 × 800 drawing of the cover. A
// line of lettering is placed by its baseline, the height of its capitals and
// the ends of its letters, and is stretched to fill that width.
#import "../book-style.typ": page-height, page-width

#let cover-x(x) = x / 547 * page-width
#let cover-y(y) = y / 800 * page-height

#let cloth = rgb("3c182c")
// The same gold fills assets/cover-drawing.svg and assets/cover-logo.svg.
#let gold = rgb("a49c59")

// The authors, by the initials and the surnames: the names stand well apart.
#let authors = (
  (body: [А. С.], left: 77.5, right: 147),
  (body: [Мищенко,], left: 156, right: 283.5),
  (body: [А. Т.], left: 305, right: 372),
  (body: [Фоменко], left: 381.5, right: 495.5),
)
#let authors-baseline = 68
#let authors-cap = 31.5

// «КУРС», letter by letter: each letter, side bearings included, is stretched
// to its box; the top and the bottom are those of the letters inside the rule.
#let course = (
  (body: "К", left: 74.5, right: 178.5),
  (body: "У", left: 197, right: 288.5),
  (body: "Р", left: 292, right: 382.5),
  (body: "С", left: 394.3, right: 495),
)
#let course-top = 101.9
#let course-bottom = 232.6
// Each letter is drawn as a gold rule of this thickness running round it at
// this distance outside it (to the middle of the rule).
#let course-rule = 2.8
#let course-offset = 4

#let title = (
  (body: [ДИФФЕРЕНЦИАЛЬНОЙ], left: 76, right: 497, baseline: 299.5),
  (body: [ГЕОМЕТРИИ], left: 175.5, right: 396.5, baseline: 355.5),
  (body: [И ТОПОЛОГИИ], left: 153, right: 418.5, baseline: 411.5),
)
#let title-cap = 33

// The drawing and the publisher's mark by their boxes; the letter χ by its
// left end and the top and bottom of its ink.
#let drawing = (left: 75, top: 441, width: 417, height: 247)
#let mark = (left: 209, top: 713, width: 149, height: 49)
#let chi = (left: 239.5, top: 437.5, bottom: 462.5)
// The printed χ is narrower and heavier than that of the math font.
#let chi-stretch = 80%
#let chi-stroke = 0.5pt

// Sets `body` from `x` stretched to `width` (or by a ratio). With `ink: false`
// its capitals are `height` high and `y` is the baseline; with `ink: true`
// its ink is `height` high and `y` is the top of the ink.
#let fit(body, x, y, height, width, ink: false) = context {
  let edges(content) = if ink {
    text(top-edge: "bounds", bottom-edge: "bounds", content)
  } else { text(top-edge: "baseline", bottom-edge: "baseline", content) }
  let probe = if ink { edges(body) } else {
    text(top-edge: "bounds", bottom-edge: "baseline", "Н")
  }
  let size = 10pt * (cover-y(height) / measure(text(size: 10pt, probe)).height)
  let shaped = text(size: size, edges(body))
  let natural = measure(shaped).width
  place(dx: cover-x(x), dy: cover-y(y), scale(
    x: if type(width) == ratio { width } else {
      cover-x(width) / natural * 100%
    },
    origin: top + left,
    box(width: natural, shaped),
  ))
}

#let cover() = page(
  width: page-width,
  height: page-height,
  margin: 0pt,
  header: none,
  footer: none,
  numbering: none,
  fill: cloth,
  {
    set text(fill: gold, lang: "ru", hyphenate: false)
    set par(first-line-indent: 0pt, justify: false)

    // The authors: a bold serif, condensed.
    {
      set text(font: "EB Garamond", weight: "extrabold", stroke: 0.2pt + gold)
      for name in authors {
        fit(
          name.body,
          name.left,
          authors-baseline,
          authors-cap,
          name.right - name.left,
        )
      }
    }

    // «КУРС»: the letters in cloth inside the gold rule, drawn as the letters
    // widened to the outer edge of the rule in gold and then to its inner
    // edge in cloth.
    {
      set text(font: "Kurale")
      for (paint, width) in (
        (gold, 2 * course-offset + course-rule),
        (cloth, 2 * course-offset - course-rule),
      ) {
        for letter in course {
          fit(
            text(
              fill: paint,
              stroke: (
                paint: paint,
                thickness: cover-x(width),
                join: "round",
              ),
              letter.body,
            ),
            letter.left,
            course-top,
            course-bottom - course-top,
            letter.right - letter.left,
            ink: true,
          )
        }
      }
    }

    // The rest of the title: condensed sans capitals, set close, with wide
    // word spaces.
    {
      set text(
        font: "Cuprum",
        weight: "bold",
        tracking: -0.04em,
        spacing: 160%,
      )
      for line in title {
        fit(
          line.body,
          line.left,
          line.baseline,
          title-cap,
          line.right - line.left,
        )
      }
    }

    // The drawing with its letter χ, and the publisher's mark.
    for (file, area) in (
      ("../../assets/cover-drawing.svg", drawing),
      ("../../assets/cover-logo.svg", mark),
    ) {
      place(dx: cover-x(area.left), dy: cover-y(area.top), image(
        file,
        width: cover-x(area.width),
        height: cover-y(area.height),
        fit: "stretch",
      ))
    }
    fit(
      text(
        font: "New Computer Modern Math",
        stroke: chi-stroke + gold,
        "\u{1D712}",
      ),
      chi.left,
      chi.top,
      chi.bottom - chi.top,
      chi-stretch,
      ink: true,
    )
  },
)
