#import "@preview/citegeist:0.2.1": load-bibliography

#import "/_template/lib.typ": trailing-slash
#import "/_template/template.typ": template, tr, ln, ct, inline-tree

#let bib = load-bibliography(read("/references.bib"))

#document("/bibliography/index.html")[
#for (key, entry) in bib {
  let identifier = key
  link("/" + identifier + "/")
  linebreak()
}
]

#for (key, entry) in bib {
  let identifier = key
  let title = entry.fields.title
  let taxon = upper(entry.entry_type.first()) + entry.entry_type.slice(1)
  let fields = entry.fields
  let parsed-names = entry.parsed_names

  template(
    identifier: identifier,
    title: title,
    taxon: taxon,
    toc: false,
    fields: fields,
    parsed-names: parsed-names,
  )(eval(fields.at("abstract", default: ""), mode: "markup"))
}
