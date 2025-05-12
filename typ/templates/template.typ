#import "../packages/html-toolkit.typ": *

/// Fonts.
// #let main-font-cn = ("Noto Sans CJK SC", "Source Han Serif SC")
// #let code-font-cn = ("Noto Sans CJK SC",)

// #let main-font = (
  // (name: "Libertinus Serif", covers: "latin-in-cjk"),
  // ..main-font-cn,
// )

// #let code-font = (
//   "BlexMono Nerd Font Mono",
//   // typst-book's embedded font
//   "DejaVu Sans Mono",
//   ..code-font-cn,
// )

/// The base of all html templates.
#let base-template(content) = {
  // todo: remove it after the bug is fixed
  show raw.where(block: false): it => html.elem("code", it.text)
  // Renders the math equations with scrollable div.
  show math.equation: set text(fill: color.rgb(0, 0, 0, 100%), font: ("IBM Plex Math", "IBM Plex Serif"), size: 13.5pt, weight: 400)
  show math.equation.where(block: false): it => html.elem("span", html.frame(it)) 
  show math.equation.where(block: true): div-frame.with(attrs: ("style": "display: flex; justify-content: center; overflow-x: auto;"))
  /// The description of the document.
  // set document(description: description) if description != none
  set text(size: 15pt)

  show: html-template

  /// The HTML content.
  content
}
