#import "/_template/template.typ": template, tr, ln, ct, inline-tree
#show: template(
  title:      [Weeknotes 21, May 2026],
  date:       datetime(year: 2026, month: 05, day: 24, hour: 20, minute: 51, second: 34),
  tags:       ("weeknotes",),
  identifier: "2026-W21",
)

#inline-tree(
  identifier: none,
  title: [NJPLS was fun!],
  expanded: true,
  disable-numbering: true,
  level: 2,
)[
  I attended this year's first #link("https://njpls.org/may2026.html")[NJPLS] this week, thanks to the generous travel support by my advisor. It was a great experience, although I was a bit upset that my talk proposal didn't make it. (Nevertheless, after listened to all the talks, I think they are indeed more interesting than mine.)

  Talks I enjoyed most were _Principal Gradual Type Inference_ by Prof. David Van Horn and _Morphosyntactic Programming: Case, Mood, and Type-Directed Disambiguation for Turkish-Like Syntax_ by Dr. Joomy Korkut.

  #inline-tree(
    identifier: none,
    title: [Discussion about gradual typing],
    expanded: true,
    disable-numbering: false,
    level: 3,
  )[
    I discussed with Prof. Van Horn about gradual typing after his talk. One of his interesting slogans in the talk was "gradual typing is about ill-typed programs." After the discussion, we thought that this claim could be somehow extended. Some programs are definitively ill-typed; for example, using something here as an integer and elsewhere as a boolean is definitively inconsistent, as well as using something here as a pair and elsewhere as a function. We may say such inconsistency violates with the value's type constructor. Meanwhile, using a function here as an `Int -> Int` and elsewhere as an `Bool -> Bool` might be okay at runtime, even the type system may lack the expressivity to type such a function. So, there are two kinds of ill-typedness in terms of gradual types: one is when you mess up with the value's _essence_, and another is when you are merely trying to bypass the inability of the type system. We also discussed some other topics.
  ]

  #inline-tree(
    identifier: none,
    title: [Non-English programming languages],
    expanded: true,
    disable-numbering: false,
    level: 3,
  )[
    Dr. Joomy Korkut presented their design of a programming language with a Turkish-Like Syntax, which allows you to use Turkish morphology on identifiers and keywords to express special semantics. I liked this idea a lot.

    I do not aim to attack English-based programming languages. They are programming languages after all, and technically one could just regard the keywords as mere symbols (just like those from logic and mathematics). And most programming languages allow Unicode identifiers.

    The interesting (to me) idea here is to utilize linguistic features of natural languages, contrary to the "symbolism" view of programming language syntax.

    This is also related to some of my thoughts on a programming language in Chinese. Although, like said above, it is easy to imagine one modifying only the lexer of a compiler/interpreter to make it use Chinese keywords and punctuation, that is not what I mean. I was thinking something more accommodated to the distinct properties of Chinese. However, different from Turkish whose morphology could be utilized, Chinese is on the other end: there is no morphology at all, and all meanings are expressed merely by combination of words instead of applying morphology to words. So morphology is not something here. Another distinct property of Chinese is that its texts does not use spaces between words and sentences at all, only line breaks between paragraphs. But this makes it sounds farther away from what a programming language may like. So, I think it still require some considerations on how to program "in Chinese".
  ]
]
