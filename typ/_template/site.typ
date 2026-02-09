#import "/_template/lib.typ": _guard-and-render-metadata, _meta-item-html

#let config = (
  math-fonts: ("Libertinus Math",),
  foreground-color: (rgb("#000000"), rgb("#ffffff")),
  default-lang: "en",
)

#let metadata-taxon-map-html = (
  "CV": (..attrs) => {
    if attrs.at("export-pdf", default: false) {
      _meta-item-html(link("/pdf/" + attrs.at("identifier", default: "") + ".pdf", "PDF Version"))
    }
    _guard-and-render-metadata("contacts", (it) => {
      it.map((contact) => {
        _meta-item-html(contact)
      }).join()
    })(attrs)
  },
  
)

#let metadata-taxon-map-paged = (:)