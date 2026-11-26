// Chapters 1–7 count on counter(heading), their sections § 1, § 2, … on its
// second level, the numbered points of a section, «1. Мотивировка.», on its
// third. Every kind of statement has a counter of its own, «Теорема 1, 2,
// …», «Лемма 1, 2, …»; they and the formula numbers restart in every section
// and at the head of a chapter, whose introduction counts apart («Пример 1»
// again in its § 1). The figures are numbered through the chapter, «Рис. 1»,
// the problems of a list «Задачи к § N» through the list.
//
// A reference prints the own number of its target, as the book does: «7» for
// a theorem, «(3)» for a formula, «2» for a section or a chapter; the text
// names the section or the chapter of a target elsewhere, «теорему 7 § 2»:
// `теорему~@th:… §~@sec:…`.
#let section-families = (
  "th",
  "lem",
  "prop",
  "stmt",
  "cor",
  "def",
  "exm",
  "rem",
  "eq",
  "ex",
  "task",
)
#let chapter-families = ("fig",)
#let list-families = ("pr",)
#let family-counter(family) = counter("numbered:" + family)
#let reset-section() = {
  for family in section-families + list-families {
    family-counter(family).update(0)
  }
}
#let reset-chapter() = {
  reset-section()
  for family in chapter-families { family-counter(family).update(0) }
}

// The chapter of a location, 0 before chapter 1.
#let chapter-of(location) = {
  let numbers = counter(heading).at(location)
  if numbers.len() == 0 { 0 } else { numbers.first() }
}

// A primed object «Определение 2′», «(3′)» shares the number of its base: its
// label is the label of the base with the ending -prime or -dprime,
// <def:name> and <def:name-prime>.
#let prime-suffixes = (prime: "′", dprime: "″")
#let label-prime(name) = {
  let found = name.match(regex("^(.+)-(prime|dprime)$"))
  if found == none { return none }
  (
    base: label(found.captures.first()),
    mark: prime-suffixes.at(found.captures.last()),
  )
}

// (own number,). A primed object counts nothing: it reads the number of its
// base. An object with a number given in the source keeps it (`fixed`).
#let object-number(family, location, prime: none, fixed: none) = {
  if prime != none {
    // The base may hold records of other families (a formula inside a
    // definition): the record of its own family gives the number.
    let base = query(selector(<numbered>).within(prime.base)).filter(it => (
      it.value.family == family
    ))
    return if base.len() == 1 {
      (str(base.first().value.number.last()) + prime.mark,)
    } else { ("?",) }
  }
  if fixed != none { return (fixed,) }
  (family-counter(family).at(location).first(),)
}

// The number as printed in a reference: the own number.
#let printed-number(number) = str(number.last())

// The number of a record, counted at its place. The value that the record
// stores is right only from the second pass of the layout on, a reference that
// reads it from the third, and the book has no pass to spare.
#let record-number(record) = {
  let value = record.value
  let at = record.location()
  if "flags" in value {
    object-number(value.family, at, ..value.flags)
  } else if value.family == "heading" {
    (counter(heading).at(at).at(value.level - 1),)
  } else { value.number }
}
#let numbered-record(target) = {
  let found = query(target)
  if found.len() != 1 { return none }
  query(selector(<numbered>).within(target)).at(0, default: none)
}
#let record(family, ..flags) = context [#metadata((
  kind: "numbered",
  family: family,
  number: object-number(family, here(), ..flags.named()),
  flags: flags.named(),
))<numbered>]
