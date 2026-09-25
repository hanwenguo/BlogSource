#import "@preview/sicons:15.13.0": sicon

#import "/_template/template.typ": ct, inline-tree, ln, template, tr

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
  ) = document(
    "pdf/CV.pdf",
    title: name,
    author: name,
    keywords: (name, "curriculum vitae", "cv", "resume"),
    {
      // Configure text properties.
      set text(size: 11pt, hyphenate: false, font: "Libertinus Serif")
      set par(justification-limits: (
        tracking: (min: -0.02em, max: 0.02em),
      ))

      // Text settings used across the template.
      let head-text = text.with(font: "Libertinus Sans", weight: "medium")
      let section-head-text = head-text.with(weight: "bold")

      // Set page properties.
      set page(
        paper: paper-size,
        margin: (
          x: 14%,
          top: if profile-picture == none { 9% } else { 8.6% },
          bottom: 9%,
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
        },
      )

      show link: set text(fill: rgb("#004C81"))

      // Display title and contact info.
      block(width: 100%, below: 1.5em)[
        #let header-info = {
          show text: upper
          head-text(size: 1.8em, tracking: 3.2pt, name)
          v(1.4em, weak: true)
          show text: it => head-text(size: 0.8em, tracking: 1.4pt, it)
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
            align(right + horizon, header-info),
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
          bottom: 0.2em,
          smallcaps(section-head-text(weight: "black", size: 0.75em, tracking: 0.6pt, it)),
        )
      }

      // Configure paragraph properties.
      set par(leading: 0.65em, justify: true, linebreaks: "optimized")

      body
    },
  )

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
      identifier: "CV",
      contacts: contacts,
      address: address,
      export-pdf: true,
    )(body)
  }

  pesha-html(
    name: name,
    contacts: contacts,
    profile-picture: profile-picture,
    body,
  )

  pesha-paged(
    name: name,
    contacts: contacts,
    profile-picture: profile-picture,
    body,
  )

  // context if target() == "html" {
  //   pesha-html(
  //     name: name,
  //     contacts: contacts,
  //     profile-picture: profile-picture,
  //     body,
  //   )
  // } else {
  //   pesha-paged(
  //     name: name,
  //     address: address,
  //     contacts: contacts,
  //     profile-picture: profile-picture,
  //     paper-size: paper-size,
  //     footer-text: footer-text,
  //     page-numbering-format: page-numbering-format,
  //     body,
  //   )
  // }
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
    html.div(
      style: "display: grid; grid-template-columns: 1fr auto; grid-template-rows: auto auto auto; grid-template-areas:
    \"top-left    top-right\"
    \"bottom-left bottom-right\"
    \"content content\"; margin: 1rem 0;",
    )[
      #html.div(style: "grid-area: top-left;")[#top-left]
      #html.div(style: "grid-area: top-right; justify-self: end;")[
        #top-right]
      #html.div(style: "grid-area: bottom-left;")[#if bottom-left != none [#bottom-left\ ]]
      #html.div(style: "grid-area: bottom-right; justify-self: end;")[
        #if bottom-right != none [#bottom-right\ ]
      ]
      #html.div(style: "grid-area: content;")[#body]
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

#let info(..others) = {
  let metadata-span = for (key, val) in others.named() [
    #link(val)[\[#smallcaps(key)\]]
  ]
  metadata-span
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
    body,
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
    info(..others)

    tile(
      top-left: emph(name),
      top-right: place,
      bottom-left: authors,
      bottom-right: metadata-span,
      body,
    )
  } else {
    tr("wb:" + identifier, show-metadata: true, expanded: false, disable-numbering: true)
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
      body,
    )
  }
}

#let ift-info = info(
  code: "https://github.com/utahplt/ift-benchmark",
  doi: "https://doi.org/10.22152/programming-journal.org/2025/10/17",
  pdf: "https://hanwen.io/publications/GG25.pdf",
  poster: "https://hanwen.io/publications/GG25-poster.pdf",
)

#let stir-info = info(
  code: "https://github.com/StirArtifact/stir",
  doi: "https://doi.org/10.1145/3611643.3616283",
  pdf: "https://hanwen.io/publications/PXY+23.pdf",
)

#show: pesha.with(
  name: "Hanwen Guo",
  // address: "5419 Hollywood Blvd Ste c731, Los Angeles, CA 90027",
  contacts: (
    // [(323) 555 1435],
    [#link("mailto:guo@hanwen.io")],
    [#link("https://hanwen.io")[hanwen.io]],
    [#link("https://github.com/hanwenguo")[GitHub]],
    [#link("https://scholar.google.com/citations?user=H-96dO8AAAAJ")[Google Scholar]],
  ),
  // footer-text: [Page#sym.space],
  paper-size: "us-letter",
)

#ilt(title: [Education])[
  #experience(
    place: [University of Utah, #text(size: 0.9em)[Ph.D. in Computer Science]],
    time: [08/2024 -- 12/2029 (expected)],
    text(
      size: 0.98em,
    )[Advisor: #link("https://www.cs.utah.edu/~blg/", "Ben Greenman") #context if target() == "paged" { $|$ } else [\ ] Research Focus: Programming Languages, Type Systems, Gradual Typing, Program Analysis],
  )

  #experience(
    place: [Wuhan University, #text(size: 0.9em)[B.Eng. in Computer Science]],
    time: [Fall 2020 -- Spring 2024],
  )[]
]

#ilt(title: "Research Experience")[

  // #if research-version {
  //   tile(
  //     top-left: [Runtime Obligations for Sound Gradual Typing],
  //     top-right: [Spring 2026 -- Present],
  //   )[
  //     - Investigating a theoretical framework for deriving runtime check obligations from different notions of soundness in gradual typing.
  //   ]
  // }

  #tile(
    top-left: [PPG: Automated Auditing for Python TypeGuard Predicates],
    top-right: [Spring 2025 -- Present],
  )[
    - Designed PPG, a hybrid static-analysis and property-based testing approach for auditing the semantic validity of Python `TypeGuard` predicates by extracting `True`-returning path constraints and synthesizing acceptance-directed Hypothesis tests.
    - Audited 308 TypeGuard predicates across 60 open-source projects (>5M lines of Python), finding 50 reproducible counterexamples across 23 projects and characterizing recurring sources of unsoundness and barriers to automated validation.
  ]
  #tile(
    top-left: [If-T: A Benchmark for Type Narrowing],
    top-right: [Fall 2024 -- Spring 2025],
  )[
    - Proposed and implemented a language-agnostic benchmark with 13 scenarios spanning three fundamental dimensions of type-narrowing design.
    - Evaluated 10 gradual type checkers (including TypeScript, Flow, mypy, Pyright, ty, Pyrefly, Sorbet, Luau) and analyzed differences in narrowing precision and supported type-narrowing designs.
    - The benchmark was later #link("https://elixir-lang.org/blog/2026/06/03/elixir-v1-20-0-released/#:~:text=In%20this%20announcement,dynamically%20typed%20programs.")[used and credited by the Elixir team] in evaluating Elixir’s type system.
  ]
  #tile(
    top-left: [#smallcaps[Stir]: Statistical Type Inference for Incomplete Programs],
    top-right: [Fall 2023 -- Spring 2024],
  )[
    - Contributed to the research artifact by restructuring benchmark workflows into a modular, parameterized architecture and optimizing the evaluation pipeline through profiling, parallelization, and C++ reimplementation of data-processing components.
  ]
]

#ilt(title: [Publications])[
  #context if target() == "paged" [
    #set par(hanging-indent: 1.4em)
    [1] Hanwen Guo, Ben Greenman. 2025. If-T: A Benchmark for Type Narrowing. _\<Programming\>_ 10.2. _Editors' Choice Award_. #ift-info
    #v(-0.55em)
    [2] Y. Peng et al. 2023. Statistical Type Inference for Incomplete Programs. _ESEC/FSE 2023_. _Best Artifact Award_. #stir-info
  ] else {
    tr("wb:GG25", show-metadata: true, expanded: false, disable-numbering: true)
    tr("wb:PXY-23", show-metadata: true, expanded: false, disable-numbering: true)
  }
]

#ilt(title: "Technical Skills")[
  - Languages: Python, C++
]

#ilt(title: [Teaching & Service])[
  #experience(
    place: [Artifact Evaluation Committee, #link("https://programming-journal.org/2026/11/issue1/")[#text(size: 0.9em)[\<Programming\> 11]]],
    time: [Spring 2026],
  )[]
  #experience(
    place: [Teaching Assistant, #text(size: 0.9em)[University of Utah]],
    title: "Programming Language, Operating Systems",
    time: [Fall 2025, Spring 2026, Fall 2026],
  )[]
]
