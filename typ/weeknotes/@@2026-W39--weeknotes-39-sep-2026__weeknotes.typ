#import "/_template/template.typ": ct, inline-tree, ln, template, tr
#show: template(
  title: [Weeknotes 39, Sep 2026],
  date: datetime(year: 2026, month: 09, day: 23, hour: 15, minute: 24, second: 24),
  tags: ("weeknotes",),
  identifier: "2026-W39",
)

#inline-tree(
  identifier: none,
  title: [Idea: plain text outline format],
  expanded: true,
  disable-numbering: false,
)[
  Recently I tried out several "outliner" software, and I generally likes the idea of writing in outline documents. It feels flexible without absolute heading levels, or more importantly, not thinking the document as "sections separated by headings" at all. However, to my surprise, all of these software either uses some proprietary format, or still uses Markdown or some other plain text format with such "heading-section" model (like Org-mode) under the hood. This makes me think: why isn't there a plain text format for outlines, just like Markdown for sectional documents?
]
