#let default_lang = sys.inputs.at("default-lang", default: "en")
#let lang = sys.inputs.at("lang", default: default_lang)
#let goal = sys.inputs.at("goal", default: "publish")
#let languages = (
  "en": [English],
)
#let tgt = sys.inputs.at("target", default: "html")
#let paged = int(tgt == "pdf")

// str: use in code blocks
#let todos = {
  (
    en: "untranslated",
  ).at(lang)
}
// content: use in other places
#let todo = text(
  fill: red,
  todos
)
// str: use in code blocks
#let todoupds(l) = {
  (
    en: "translation is outdated",
  ).at(lang)
} // content: use in other places
#let todoupd(l) = text(
  fill: orange,
  todoupds(l)
)

// content: use in other places
#let tr(dict, default: todo) = {
  if true {
    for l in dict.keys() {
      assert(l in languages, message: "Language `"+l+"` is not supported yet")
    }
  }
  dict.at(
    lang,
    default: if default != todo and default != todos { default }
    else if goal == "publish" { dict.at(default_lang) }
    else { default }
  )
}

// str: use in code blocks
#let ts = tr.with(default: todos)

#let h1(it, offset: 0) = {
  if type(it) == dictionary {
    it = tr(it)
  }
  if tgt == "pdf" {
    heading(it, depth: 1, offset: offset)
  } else {
    title(it)
  }
}

#let include-code(path, lang: "rust", block: true, prefix: "", suffix: "", anchor: none, lines: none) = {
  let file = read(path)
  let code = if type(anchor) == str {
    let lines = file.split("\n")
    let left = lines.position(l => { regex("ANCHOR:\s+"+anchor) in l })
    let right = lines.position(l => { regex("ANCHOR_END:\s+"+anchor) in l })
    lines.slice(left+1, right).join("\n")
  } else if type(lines) == int {
    file.split("\n").at(lines - 1)
  } else if type(lines) == array {
    file.split("\n").slice(lines.at(0) - 1, lines.at(1)).join("\n")
  } else {
    file
  }
  raw(prefix + code + suffix, lang: lang, block: block)
}


