#import "/_template/template.typ": _default-metadata, template as default-template

#let template(
  identifier: "",
  title: "",
  ..attrs,
) = doc => {
  default-template(
    identifier: identifier,
    title: title,
    ..attrs,
    lang: "zh"
  )({
    show raw.where(lang: "poem"): (it) => {
      html.div(class: "poem", it.text)
    }
    doc
  })
}
