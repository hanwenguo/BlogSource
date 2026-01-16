#import "_lib.typ": *
#import "@preview/sicons:15.13.0": sicon

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

= Research Interests
Programming Languages, Gradual Typing, Computer Education

Or: How to make programming friendlier while preserving, and maybe even improving, guarantees?

= Education
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

= Publications
#publication(
  name: "If-T: A Benchmark for Type Narrowing",
  place: "Programming 10.2",
  authors: [Hanwen Guo, Ben Greenman],
  doi: "https://doi.org/10.22152/programming-journal.org/2025/10/17",
)[]

#publication(
  name: "Statistical Type Inference for Incomplete Programs",
  place: "ESEC/FSE 2023",
  authors: text(tracking: -0.1pt)[Yaohui Peng, Jing Xie, Qiongling Yang, Hanwen Guo, Qingan Li, Jingling Xue, Mengting Yuan],
  doi: "https://doi.org/10.1145/3611643.3616283",
)[Best Artifact Award]

= Service
#experience(
  place: [Artifact Evaluation Committee],
  title: [Programming 11.1],
)[]

= Honors & Awards
#experience(
  place: "Best Artifact Award",
  time: [ESEC/FSE 2023],
)[]

= Teaching
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