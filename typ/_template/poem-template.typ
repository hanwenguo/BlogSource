#import "/_template/site.typ"
#import "/_template/lib.typ": plain-text, domain, root-dir, trailing-slash, target, _guard-and-render-metadata, _meta-item-html as _meta-item
#import "/_template/template-paged.typ": template-paged

#let _default-metadata = (..attrs) => {
  _guard-and-render-metadata("date", (it) => {
    _meta-item(it.display("[month repr:long] [day], [year]"))
  })(attrs)
  _guard-and-render-metadata("author", (it) => {
    _meta-item(html.address(class: "author", {
      it.map((a) => { a }).join(", ")
    }))
  })(attrs)
  if attrs.at("export-pdf", default: false) {
    _meta-item(link("/pdf/" + attrs.at("identifier", default: "") + ".pdf", "PDF"))
  }
}

#let _summary_header(
  level: 1,
  inline: false,
  disable-numbering: false,
  identifier: none,
  title: none,
  ..attrs,
) = {
  let heading-attrs = (:)
  if identifier != none {
    heading-attrs.insert("id", identifier)
  }
  if disable-numbering {
    heading-attrs.insert("class", "disable-numbering")
  }
  html.summary(
    html.header({
      html.elem("h" + str(level), attrs: heading-attrs, {
        if attrs.at("taxon", default: none) != none {
          html.span(class: "taxon", attrs.at("taxon"))
        }
        title
        " "
        if identifier != none {
          let href = if inline {
            "#" + identifier
          } else {
            root-dir + identifier + (if trailing-slash { "/" } else { ".html" })
          }
          html.a(class: "slug", href: href, "[" + identifier + "]")
        }
      })
      html.div(class: "metadata", {
        html.ul(
          _default-metadata(identifier: identifier, ..attrs)
        )
      })
    })
  )
}

#let _head(
  identifier: none,
  title: none,
  ..attrs,
) = {
  html.head({
    html.meta(name: "identifier", content: identifier)
    html.meta(name: "toc", content: "false")
    if attrs.at("export-pdf", default: false) {
      html.meta(name: "export-pdf", content: "true")
    } else {
      html.meta(name: "export-pdf", content: "false")
    }
    html.meta(name: "lang", content: "zh")
    html.meta(name: "poem", content: "true")
    html.title(plain-text(title))
  })
}

#let _body(
  body,
  identifier: none,
  title: none,
  ..attrs,
) = {
  html.body({
    _summary_header(
      level: 1,
      identifier: identifier,
      title: title,
      ..attrs
    ) 
    body
  })
}

#let template-html(
  identifier: "",
  title: "", 
  ..attrs,
) = (doc) => {
  show raw.where(lang: "poem"): (it) => {
    html.div(class: "poem", it.text)
  }

  show link: it => html.span(
    class: "link external",
    html.a(
      href: it.dest,
      it.body
    )
  )

  show footnote: it => html.aside(it.body)
  
  html.html({
    _head(
      identifier: identifier,
      title: title,
      ..attrs
    )
    _body(
      doc,
      identifier: identifier,
      title: title,
      ..attrs
    )
  })
}

#let template = if target == "html" {
  template-html
} else {
  template-paged
}
