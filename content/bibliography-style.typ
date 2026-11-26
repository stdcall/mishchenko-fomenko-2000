// The literature of the editorial notes: a numbered list, the names in
// italics, «[3] Энгелькинг Р. Общая топология. …». A note names the author in
// words and cites the work with its place: `Энгелькинг @bib:Engelking1986[упр.
// 2.3.C]` prints «Энгелькинг [3, упр. 2.3.C]». Every description is generated
// from editorial.bib; this file only orders the records.
#import "bibliography-data.typ": bibliography-data, name-parts
#import "numbering.typ": record
#import "main-defs.typ": reference-rules

// `annotation` is the printed description with substitutions: {title},
// {pages}, … from this record, {Key.pages} from a related component;
// `_{booktitle}_` sets a value in italics. `_…_` in a value is emphasis,
// `$…$` mathematics.
#let rich-bib-text(value) = {
  // An abbreviation stays with the number or word after it: «vol. 8».
  let value = value
    .replace("'", "’")
    .replace("--", "–")
    .replace("~", "\u{00a0}")
    .replace(
      regex("\\b(vol|Vol|Bd|ser|Ser|No|Nr|ed|т|вып|гл|ч|изд|p|pp|S|стр)\\. "),
      m => m.text.slice(0, -1) + "\u{00a0}",
    )
  let position = 0
  for match in value.matches(regex("_[^_]+_|\\$[^$]+\\$")) {
    value.slice(position, match.start)
    let part = match.text
    if part.starts-with("_") {
      emph(part.slice(1, -1))
    } else { eval(part, mode: "markup") }
    position = match.end
  }
  value.slice(position)
}

// A name as Russian lists print it, the surname first, then the initials,
// which do not break: «Зорич В. А.», «Tu L. W.»; "Jr." after a comma.
#let print-name(name) = {
  let parts = name-parts(name)
  let shown = parts.family
  if parts.given != none {
    shown = shown + "\u{00a0}" + parts.given.replace(" ", "\u{00a0}")
  }
  if parts.suffix != none { shown = shown + ", " + parts.suffix }
  shown
}
// Several names are joined by commas.
#let print-names(value) = value.split(" and ").map(print-name).join(", ")

// The entries follow each other at the leading of the text.
#let entry-spacing = 0.52em

// Page list of the mentions of a work, each linked to its mention.
#let bib-backlinks(target) = context {
  let refs = query(<bibliography-mention>).filter(it => {
    let value = it.value
    (
      type(value) == dictionary
        and value.at("target", default: none) == target
        and value.at("bibliographic-mention", default: true)
    )
  })
  let seen = ()
  let pages = ()
  for mention in refs.sorted(key: it => it.location().page()) {
    let loc = mention.location()
    if not seen.contains(loc.page()) {
      seen.push(loc.page())
      let position = loc.position()
      let destination = (
        page: position.page,
        x: position.x,
        y: calc.max(0pt, position.y - 8pt),
      )
      let shown = str(counter(page).at(loc).first())
      pages.push(box(context [
        #metadata((
          kind: "page-reference",
          resolved: true,
          target: "bib-mention:" + target,
          position: here().position(),
          target-position: position,
          // Typst adds 10pt above the coordinate destination as well.
          destination-offset-pt: 18,
          description: shown,
        ))
        #link(destination, shown)
      ]))
    }
  }
  if pages.len() > 0 [ #text(size: 7.5pt)[\[с.~#pages.join(", ")\]]]
}

// The printed description of a record from its annotation template. The
// journal is printed abbreviated, `shortjournal` when there is one, and the
// volume of a journal in bold; {author} prints the names as in the list.
#let bib-description(key) = {
  let entry = bibliography-data.at(key)
  let related = entry
    .at("related", default: "")
    .split(",")
    .map(k => k.trim())
    .filter(k => k != "")
  let template = entry.annotation
  let position = 0
  for match in template.matches(regex("([_*]?)\\{([^{}]+)\\}([_*]?)")) {
    rich-bib-text(template.slice(position, match.start))
    let (before, name, after) = match.captures
    position = match.end
    // {cite:Key}: a reference to another work of the list, not a mention
    // of it.
    if name.starts-with("cite:") {
      [#before#reference-rules(
          ref(label("bib:" + name.slice(5))),
          bibliographic-mention: false,
        )#after]
      continue
    }
    let token = name.split(".")
    let data = if token.len() == 1 { entry } else {
      assert(
        token.first() in related,
        message: "Template references an unrelated bibliography record",
      )
      bibliography-data.at(token.first())
    }
    let field = token.last()
    assert(field in data, message: "No field " + name + " for " + key)
    let value = if field == "journal" {
      rich-bib-text(data.at("shortjournal", default: data.journal))
    } else if field == "author" {
      print-names(data.author)
    } else if field == "volume" and "journal" in data {
      strong(rich-bib-text(data.volume))
    } else {
      rich-bib-text(data.at(field))
    }
    if before == "_" and after == "_" { emph(value) } else if (
      before == "*" and after == "*"
    ) { strong(value) } else [#before#value#after]
  }
  rich-bib-text(template.slice(position))
  // A composite record (a paper and its correction) lists its DOIs in turn.
  let dois = (key, ..related)
    .map(component => bibliography-data.at(component).at("doi", default: none))
    .filter(doi => doi != none)
  // A line may end after the first slash and, in the suffix, after a hyphen,
  // a point or a slash («S0002-9947-1959-…» would not break otherwise; before a
  // hyphen the word joiner of the hyphen rule forbids a break). A break point
  // is a vanishing space: it adds no character to the text of the DOI (a
  // zero-width space would), and `h(0pt)` gives no break point.
  let break-point = h(0.001pt)
  let shown(doi) = {
    let (prefix, ..rest) = doi.split("/")
    let pieces = ("",)
    for character in rest.join("/").clusters() {
      pieces.at(-1) += character
      if character in ("-", ".", "/") { pieces.push("") }
    }
    [DOI: #prefix/#break-point#pieces.join(break-point)]
  }
  if dois.len() > 0 {
    [ ]
    dois.map(doi => link("https://doi.org/" + doi, shown(doi))).join("; ")
  }
}

// The editor's text that opens a list: its references to the list itself
// are not mentions of the works.
#let bib-preface(body) = reference-rules(body, bibliographic-mention: false)

// A work of the list: `#bib-item("Tu2011") <bib:Tu2011>`, numbered in the
// order of the list; a reference prints the number, «[6]».
#let bib-number = counter("bib-number")
#let bib-item(key) = {
  let entry = bibliography-data.at(key)
  // Words in Latin letters hyphenate by the language of the work; a Russian
  // description keeps the Russian rules.
  let lang = (english: "en", french: "fr", german: "de").at(
    entry.at("language", default: "english"),
    default: "en",
  )
  show regex("\p{Latin}[\p{Latin}'’]*"): set text(lang: lang)
  bib-number.step()
  block(spacing: entry-spacing, width: 100%, context {
    let shown = str(bib-number.get().first())
    grid(
      columns: (2.2em, 1fr),
      [#record("bib", fixed: shown)\[#shown\]],
      par(first-line-indent: 0pt)[#emph(print-names(entry.author))
        #bib-description(key)#bib-backlinks("bib:" + key)],
    )
  })
}
