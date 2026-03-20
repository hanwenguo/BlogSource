#import "@preview/sicons:15.13.0": sicon

#import "/_template/template.typ": template, tr, ln, ct, inline-tree

#let pesha(
  name: "",
  address: none,
  contacts: (),
  profile-picture: none,
  paper-size: "a4",
  footer-text: none,
  page-numbering-format: "1 of 1",
  body,
) = {
  let pesha-paged(
    name: "",
    address: none,
    contacts: (),
    profile-picture: none,
    paper-size: "a4",
    footer-text: none,
    page-numbering-format: "1 of 1",
    body,
  ) = {
    // Set document metadata.
    set document(
      title: name,
      author: name,
      keywords: (name, "curriculum vitae", "cv", "resume"),
    )

    // Configure text properties.
    set text(size: 11pt, hyphenate: false, font: "Libertinus Serif")

    // Text settings used across the template.
    let head-text = text.with(font: "Libertinus Sans", weight: "medium")
    let section-head-text = head-text.with(weight: "bold")

    // Set page properties.
    set page(
      paper: paper-size,
      margin: (
        x: 14%,
        top: if profile-picture == none {13%} else {8.6%},
        bottom: 10%,
      ),
      // Display page number in footer only if there is more than one page.
      footer: context {
        set align(center)
        show text: it => head-text(size: 0.85em, tracking: 1.2pt, it)
        let total = counter(page).final().first()
        if total > 1 {
          let i = counter(page).at(here()).first()
          upper[#footer-text #counter(page).display(page-numbering-format, both: true)]
        } else {
          upper[#footer-text]
        }
      }
    )

    show link: set text(fill: rgb("#004C81"))

    // Display title and contact info.
    block(width: 100%, below: 1.5em)[
      #let header-info = {
        show text: upper
        head-text(size: 1.8em, tracking: 3.2pt, name)
        v(1.4em, weak: true)
        show text: it => head-text(size: 0.86em, tracking: 1.4pt, it)
        if address != none { address }
        if contacts.len() > 0 {
          v(1em, weak: true)
          grid(columns: contacts.len(), align: horizon, gutter: 1em, ..contacts)
        }
      }
      #if profile-picture != none {
        grid(
          columns: (1fr, auto),
          box(
            clip: true,
            width: 3.3cm,
            height: 3.3cm,
            radius: 2.5cm,
            profile-picture,
          ),
          align(right + horizon, header-info)
        )
      } else {
        align(center, header-info)
      }
    ]

    // Configure heading properties.
    show heading: it => {
      pad(left: -0.25em, line(length: 100% + 0.25em, stroke: 0.5pt))
      pad(
        top: -0.85em,
        bottom: 0.6em,
        smallcaps(section-head-text(weight: "black", size: 0.75em, tracking: 0.6pt, it)),
      )
    }

    // Configure paragraph properties.
    set par(leading: 0.7em, justify: true, linebreaks: "optimized")

    body
  }

  let pesha-html(
    name: "",
    address: none,
    contacts: (),
    profile-picture: none,
    paper-size: "a4",
    footer-text: none,
    page-numbering-format: "1 of 1",
    body,
  ) = {
    template(
      title: name,
      taxon: "CV",
      identifier: "0000",
      contacts: contacts,
      address: address,
      export-pdf: true,
    )(body)
  }

  context if target() == "html" {
    pesha-html(
      name: name,
      contacts: contacts,
      profile-picture: profile-picture,
      body,
    )
  } else {
    pesha-paged(
      name: name,
      address: address,
      contacts: contacts,
      profile-picture: profile-picture,
      paper-size: paper-size,
      footer-text: footer-text,
      page-numbering-format: page-numbering-format,
      body,
    )
  }
}

#let tile(
  body,
  top-left: none,
  top-right: none,
  bottom-left: none,
  bottom-right: none,
) = {
  let tile-paged(
    body,
    top-left: none,
    top-right: none,
    bottom-left: none,
    bottom-right: none,
  ) = {
    block(width: 100%)[
      #top-left #h(1fr) #top-right
      #if bottom-left != none [
        #set text(size: 0.9em)
        #v(0.65em, weak: true)
        #bottom-left #if bottom-right != none [ #h(1fr) #bottom-right ]
      ]
      #v(0.65em, weak: true)
      #body
    ]
  }

  let tile-html(
    body,
    top-left: none,
    top-right: none,
    bottom-left: none,
    bottom-right: none,
  ) = {
    html.div(style: "display: flex; flex-direction: row; flex-wrap: wrap; margin: 1rem 0;")[
      #html.div(style: "flex: 1 1; min-width: 9rem;")[#top-right]
      #html.div(style: "flex: 2 1; min-width: 12rem;")[
        #top-left \        
        #if bottom-left != none [#bottom-left\ ]
        #if bottom-right != none [#bottom-right\ ]
        #body
      ]
    ]
  }

  context if target() == "paged" {
    tile-paged(
      body,
      top-left: top-left,
      top-right: top-right,
      bottom-left: bottom-left,
      bottom-right: bottom-right,
    )
  } else {
    tile-html(
      body,
      top-left: top-left,
      top-right: top-right,
      bottom-left: bottom-left,
      bottom-right: bottom-right,
    )
  }
}

#let experience(
  body,
  place: none,
  title: none,
  location: none,
  time: none,
) = {
  tile(
    top-left: place,
    top-right: time,
    bottom-left: title,
    bottom-right: location,
    body
  )
}


#let publication(
  body,
  identifier: none,
  name: none,
  place: none,
  authors: none,
  ..others,
) = {
  context if target() == "paged" {
    let metadata-span = for (key, val) in others.named() [
      #link(val)[\[#smallcaps(key)\]]
    ]

    tile(
      top-left: emph(name),
      top-right: place,
      bottom-left: authors,
      bottom-right: metadata-span,
      body
    )
  } else {
    tr("wb:" + identifier, show-metadata: true, expanded: false, disable-numbering: true, demote-headings: 2)
  }
}

#let ilt(
  body,
  identifier: none,
  title: none,
  expanded: true,
  disable-numbering: true,
  ..attrs,
) = {
  context if target() == "paged" {
    heading(title, depth: 1)
    body
  } else {
    inline-tree(
      title: title,
      identifier: identifier,
      expanded: expanded,
      disable-numbering: disable-numbering,
      ..attrs,
      body
    )
  }
}

#show: pesha.with(
  name: "Hanwen Guo",
  // address: "5419 Hollywood Blvd Ste c731, Los Angeles, CA 90027",
  contacts: (
    // [(323) 555 1435],
    [#link("mailto:guo@hanwen.io")],
    [#link("mailto:hanwen.guo@utah.edu")],
    [#link("https://github.com/hanwenguo")[
      #context if target() == "paged" { sicon(slug: "github") } else { text("GitHub") }
    ]],
    [#link("https://scholar.google.com/citations?user=H-96dO8AAAAJ")[
      #context if target() == "paged" { sicon(slug: "googlescholar") } else { text("Google Scholar") }
    ]],
    [#link("https://orcid.org/0009-0000-7118-2145")[
      #context if target() == "paged" { sicon(slug: "orcid") } else { text("ORCID") }
    ]],
  ),
  // footer-text: [Page#sym.space],
  paper-size: "us-letter",
)

#ilt(
  title: [Research Interests],
)[
Programming Languages, Type Systems, Gradual Typing

Or: How to reduce the friction and improve the ergonomics of adopting strong guarantees?
]

#ilt(
  title: [Education],
)[
#experience(
  place: "University of Utah",
  time: [Fall 2024 -- present],
  title: [Ph.D. Student in Computer Science\ Advisor: #link("https://www.cs.utah.edu/~blg/", "Ben Greenman")],
)[]

#experience(
  place: "Wuhan University",
  time: [Fall 2020 -- Spring 2024],
  title: [B.Eng. in Computer Science],
)[]
]

#ilt(
  title: [Publications],
)[
#publication(
  identifier: "guo-IfTBenchmarkTypeNarrowing-2025",
  name: "If-T: A Benchmark for Type Narrowing",
  place: "Programming 10.2",
  authors: [Hanwen Guo, Ben Greenman],
  doi: "https://doi.org/10.22152/programming-journal.org/2025/10/17",
)[Editors' Choice Award]

#publication(
  identifier: "peng-StatisticalTypeInferenceIncompletePrograms-2023",
  name: "Statistical Type Inference for Incomplete Programs",
  place: "ESEC/FSE 2023",
  authors: text(tracking: -0.1pt)[Yaohui Peng, Jing Xie, Qiongling Yang, Hanwen Guo, Qingan Li, Jingling Xue, Mengting Yuan],
  doi: "https://doi.org/10.1145/3611643.3616283",
)[Best Artifact Award]
]

#ilt(
  title: [Honors & Awards],
)[
#experience(
  place: "Editors' Choice Award",
  time: [Programming 10.2 (2025)],
)[]

#experience(
  place: "Best Artifact Award",
  time: [ESEC/FSE 2023],
)[]
]

#ilt(
  title: [Service],
)[
#experience(
  place: [Artifact Evaluation Committee],
  time: [Programming 11.1],
)[]
]

#ilt(
  title: [Teaching],
)[
#experience(
  place: "Programming Language",
  title: "Teaching Assistant",
  time: [Fall 2025],
  location: "University of Utah",
)[]

#experience(
  place: "Operating Systems",
  title: "Teaching Assistant",
  time: [Spring 2026],
  location: "University of Utah",
)[]
]