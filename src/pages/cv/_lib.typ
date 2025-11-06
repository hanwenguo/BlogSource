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
    set text(size: 12pt, hyphenate: false, font: "Libertinus Serif")

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
    ..,
    body,
  ) = {
    // html.article[
    //   #html.h1(name)
    //   #html.div(class: "post-meta")[
    //     #for contact in contacts {
    //       html.p(contact)
    //     }
    //   ]
    //   #body
    // ]
    html.elem("article", {
      html.elem("h1")[#name]
      html.elem("div", html.elem("a", attrs: (href: "/cv.pdf"))[PDF Version])
      html.elem("div", attrs: (class: "post-meta"))[
        #for contact in contacts {
          html.elem("p")[#contact]
        }
      ]
      body
    })
  }

  context if target() == "paged" {
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
  } else {
    pesha-html(
      name: name,
      address: address,
      contacts: contacts,
      profile-picture: profile-picture,
      body,
    )
  }
}

// #let pesha = if sys.inputs.at("x-target", default: "paged") == "paged" {
//   pesha-paged
// } else {
//   pesha-html
// }

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
    // html.div(style: "display: grid; grid-template-columns: 12rem 1fr; gap: 1rem;")[
    //   #html.div(top-right)
    //   #html.div[
    //     #top-left
    //     #html.br()
    //     #bottom-left
    //     #html.br()
    //     #bottom-right
    //     #html.br()
    //     #body
    //   ]
    // ]
    // html.elem("div", attrs: (style: "display: grid; grid-template-columns: 12rem 1fr; gap: 1rem;"))[
    //   #html.elem("div")[#top-right]
    //   #html.elem("div")[
    //     #top-left
    //     #html.elem("br")[]
    //     #bottom-left
    //     #html.elem("br")[]
    //     #bottom-right
    //     #html.elem("br")[]
    //     #body
    //   ]
    // ]
    html.elem("div", attrs: (style: "display: flex; flex-direction: row; flex-wrap: wrap; margin: 1rem 0;"))[
      #html.elem("div", attrs: (style: "flex: 1 1; min-width: 9rem;"))[#top-right]
      #html.elem("div", attrs: (style: "flex: 2 1; min-width: 12rem;"))[
        #top-left
        #html.elem("br")[]
        #if bottom-left != none [
          #bottom-left
          #html.elem("br")[]
        ]
        #if bottom-right != none [
          #bottom-right
          #html.elem("br")[]
        ]
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

// #let tile = if sys.inputs.at("x-target", default: "paged") == "paged" { tile-paged } else { tile-html }
// #let tile = context if target() == "paged" { tile-paged } else { tile-html }

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
  name: none,
  place: none,
  authors: none,
  ..others,
) = {
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
}