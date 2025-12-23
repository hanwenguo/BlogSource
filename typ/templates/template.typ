/// The base of all html templates.
#let base-template(content, title: "", date: "", tags: (), lang: "en") = {
  show raw.where(block: false): it => html.code(it.text)
  // Renders the math equations with scrollable div.
  show math.equation: set text(fill: color.rgb(0, 0, 0, 100%), font: ("IBM Plex Math", "IBM Plex Serif"), size: 13.5pt, weight: 400)
  // show math.equation: set text(top-edge: "bounds", bottom-edge: "bounds")
  show math.equation.where(block: false): it => html.span(html.frame(it))
  show math.equation.where(block: true): it => html.div(style: "display: flex; justify-content: center; overflow-x: auto;", html.frame(it))
  set text(size: 15pt, lang: lang)

  [#metadata((
    title: title,
    date: date,
    tags: tags,
  )) <frontmatter>]

  /// The HTML content.
  content
}
