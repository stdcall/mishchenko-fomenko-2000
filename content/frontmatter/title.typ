#import "../main-defs.typ": source, spaced

#let front-page(body) = page(header: none, footer: none, {
  set par(first-line-indent: 0pt, justify: false)
  body
})

// Page 1: the title page. The series in italic over a double rule, the
// authors and «К У Р С» in a decorative roman, the title in narrow capitals
// stepped to the right, the imprint at the foot. Places and widths are those
// of the printed page, in millimetres from the left edge of the type area and
// from the top of the page; each line is set at the size that gives its
// printed width.
#let fit(body, width, font: auto, tracking: 0pt) = context {
  let shown(size) = {
    set text(size: size, tracking: tracking)
    set text(font: font) if font != auto
    body
  }
  let natural = measure(shown(10pt)).width
  shown(10pt * (width / natural))
}
// A line at a given size, its letters spaced to the printed width.
#let spread(word, width, size, font: "Cuprum") = context {
  let natural = measure(text(font: font, size: size, word)).width
  let gaps = word.clusters().len() - 1
  box(text(font: font, size: size, tracking: (width - natural) / gaps, word))
}
#let at(dx, dy, body) = place(top + left, dx: dx, dy: dy, body)

// The narrow capitals of the title are 8.7 mm high.
#let title-size = 8.7mm / 0.7
#let title-page() = page(
  header: none,
  footer: none,
  margin: (x: 16.3mm, y: 0pt),
  {
    set par(first-line-indent: 0pt, justify: false, leading: 0.3em)
    source(1)
    at(11mm, 16.5mm, fit(
      text(style: "italic")[Университетский],
      91.3mm,
    ))
    at(32mm, 26.1mm, fit(text(style: "italic")[учебник], 46mm))
    at(0mm, 39.9mm, line(length: 100%, stroke: 1pt))
    at(0mm, 41.3mm, line(length: 100%, stroke: 0.5pt))
    at(1.1mm, 50.5mm, box(width: 110mm, {
      set text(font: "Kurale", size: 17pt)
      [А.~С.~МИЩЕНКО#h(1fr)А.~Т.~ФОМЕНКО]
    }))
    at(29.9mm, 71.9mm, box(width: 52.4mm, text(font: "Kurale", size: 40pt)[
      К#h(1fr)У#h(1fr)Р#h(1fr)С
    ]))
    at(-1.2mm, 88.7mm, spread("ДИФФЕРЕНЦИАЛЬНОЙ", 114.6mm, title-size))
    at(14.9mm, 105.5mm, spread("ГЕОМЕТРИИ", 69mm, title-size))
    at(27.9mm, 119.3mm, spread("И ТОПОЛОГИИ", 84.3mm, title-size))
    at(27.5mm, 182.2mm, fit(
      [Москва#h(1em)„Факториал Пресс“#h(1em)2000],
      58mm,
    ))
  },
)

// The EAN-13 symbol of the ISBN, drawn from its digits: the first digit
// selects the parity pattern of the left half; guard bars run longer.
#let ean13(digits) = {
  let l-codes = (
    "0001101",
    "0011001",
    "0010011",
    "0111101",
    "0100011",
    "0110001",
    "0101111",
    "0111011",
    "0110111",
    "0001011",
  )
  // R codes are the complements of L codes, G codes the R codes reversed.
  let r-code(d) = l-codes
    .at(d)
    .clusters()
    .map(b => if b == "0" { "1" } else { "0" })
    .join()
  let g-code(d) = r-code(d).rev()
  let parity = (
    "LLLLLL",
    "LLGLGG",
    "LLGGLG",
    "LLGGGL",
    "LGLLGG",
    "LGGLLG",
    "LGGGLL",
    "LGLGLG",
    "LGLGGL",
    "LGGLGL",
  )
  let d = digits.clusters().map(int)
  let total = range(12)
    .map(i => d.at(i) * if calc.odd(i) { 3 } else { 1 })
    .sum()
  assert(
    calc.rem(10 - calc.rem(total, 10), 10) == d.at(12),
    message: "EAN-13 check digit",
  )
  // (pattern, guard) pieces from left to right.
  let pieces = (("101", true),)
  for i in range(6) {
    let side = parity.at(d.at(0)).at(i)
    let digit = d.at(i + 1)
    pieces.push((
      if side == "L" { l-codes.at(digit) } else { g-code(digit) },
      false,
    ))
  }
  pieces.push(("01010", true))
  for i in range(6) { pieces.push((r-code(d.at(i + 7)), false)) }
  pieces.push(("101", true))
  let module = 0.33mm
  let height = 18mm
  let x = 0
  let bars = ()
  for (pattern, guard) in pieces {
    for bit in pattern.clusters() {
      if bit == "1" {
        bars.push(place(left + top, dx: 11 * module + x * module, rect(
          width: module,
          height: if guard { height + 1.6mm } else { height },
          fill: black,
          stroke: none,
        )))
      }
      x += 1
    }
  }
  let label(body, dx, width) = place(
    left + top,
    dx: dx,
    dy: height + 0.2mm,
    box(width: width, align(center, text(size: 7.5pt, body))),
  )
  box(width: (x + 18) * module, height: height + 3.6mm, {
    bars.join()
    place(left + top, dy: height + 0.2mm, text(size: 7.5pt, str(d.at(0))))
    label(d.slice(1, 7).map(str).join(), 14 * module, 42 * module)
    label(d.slice(7, 13).map(str).join(), 61 * module, 42 * module)
  })
}

// The mark of the Russian Foundation for Basic Research, «РФФИ» with its
// two letters Ф joined.
#let rffi-mark = text(size: 22pt, tracking: -0.05em)[Р#h(-0.08em)ФФ#h(
    -0.08em,
  )И]

// The logo of the typesetting system, «AP-TeX».
#let ap-tex = [#text(weight: "bold")[AP]-T#h(-0.1667em)#box(move(
    dy: 0.22em,
    [E],
  ))#h(-0.125em)X]

// Page 2: the catalogue record, the annotation and the imprint.
#let imprint-page() = front-page[
  #source(2)
  #set text(size: 9pt)
  #set par(leading: 0.45em, spacing: 0.6em)
  #grid(
    columns: (20mm, 1fr),
    [ББК 22.151\ #h(1.2em)М71\ УДК 513.73],
    align(center + horizon, [#spaced[СЕРИЯ] «УНИВЕРСИТЕТСКИЙ УЧЕБНИК»]),
  )
  #v(3mm)
  #grid(
    columns: (20mm, 1fr),
    row-gutter: 0.4em,
    [М71], text(size: 10pt)[*Мищенко А.~С., Фоменко А.~Т.*],
    [],
    text(size: 10pt)[Курс дифференциальной геометрии и топологии.~—\
      М.: Изд-во «Факториал Пресс», 2000.~— 448~с.\
      ISBN 5-88688-048-8.],
  )
  #v(2mm)
  #pad(left: 20mm, {
    set text(size: 8pt)
    set par(justify: true, first-line-indent: (amount: 1.5em, all: true))
    [Книга представляет собой курс дифференциальной геометрии, читаемый в
      течение двух семестров на математических факультетах университетов. Она
      содержит основной программный материал по общей топологии, нелинейным
      системам координат, теории гладких многообразий, теории кривых и
      поверхностей, группам преобразований, тензорному анализу и римановой
      геометрии, теории интегрирования и гомологиям, фундаментальным группам
      поверхностей, вариационным принципам в римановой геометрии.]
    parbreak()
    [Изложение иллюстрируется большим количеством примеров и сопровождается
      задачами, часто содержащими дополнительный материал.]
    parbreak()
    [Для математиков и физиков~— студентов, аспирантов, преподавателей и научных
      работников.]
  })
  #line(length: 100%, stroke: 0.6pt)
  #grid(
    columns: (1fr, 1.45fr),
    align: (left + horizon, left + horizon),
    rffi-mark,
    par(justify: true)[Издание осуществлено при финансовой поддержке Российского
      фонда фундаментальных исследований. Проект №~96-01-14189.],
  )
  #line(length: 100%, stroke: 0.6pt)
  #v(1mm)
  Научное издание\
  #pad(left: 12mm)[_Мищенко Александр Сергеевич_#h(2em)_Фоменко Анатолий
    Тимофеевич_]
  #align(center)[Курс дифференциальной геометрии и топологии]
  Рисунки А.~Т.~Фоменко
  #v(1mm)
  #line(length: 100%, stroke: 0.4pt)
  #par(justify: true)[Формат 60~×~90/16. Усл. печ. л. 28. Бумага офсетная №~1.
    Гарнитура литературная. Подписано к печати 25.04.2000. Тираж 3000 экз. Заказ
    №~68.]
  #par(justify: true)[Издательство «Факториал Пресс», 117449, Москва, а/я 331;
    ЛР ИД №~00316 от 22.10.1999.]
  #pad(left: 1.2em)[e/mail: factorial\@mail.compnet.ru#h(
      1fr,
    )http://www.compnet.ru/factorial.]
  #par(justify: true)[Отпечатано с готовых диапозитивов издательства «Факториал
    Пресс» в ППП типографии «Наука» Академиздатцентра «Наука» РАН. 121099,
    Москва Г-99, Шубинский пер., 6.]
  #line(length: 100%, stroke: 0.4pt)
  #align(center)[Оригинал-макет подготовлен с использованием издательской
    системы #ap-tex.]
  #v(1fr)
  #grid(
    columns: (1fr, 1fr),
    align: (left + bottom, left + bottom),
    [ISBN 5-88688-048-8\ #ean13("9785886880489")],
    [©~А.~С.~Мищенко, А.~Т.~Фоменко, 2000.\ #v(1mm) ©~Факториал Пресс, 2000],
  )
]
