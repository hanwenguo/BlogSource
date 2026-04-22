#import "/_template/template.typ": template, tr, ln, ct, inline-tree
#show: template(
  title:      [Gradual Typing Reading Notes],
  date:       datetime(year: 2026, month: 04, day: 01, hour: 14, minute: 52, second: 14),
  tags:       (),
  identifier: "000T",
)

#tr("wb:000V")

#inline-tree(
  title: "Notes on Gradual Type Inference"
)[
#tr("wb:msi-Dynamictypeinference-2019", show-metadata: true, expanded: false, disable-numbering: true)

My feeling is that the problems described in section 1.3 and section 1.4 of this paper are somehow not as severe as they might initially appear. The problem is basically that some programs left you so-called undecided type variables, which can be instantiated to any type; these undecided type variables are usually introduced due to the presence of the $?$ type, which hides useful information from other parts of the program. This brings two problems:

1. If you fill in the undecided type variables with some concrete types, the program will reduce to a value, while some other choices of types will lead to divergence.
2. Even if you fill in the undecided type variables with the $?$ type, that would allow the program even if there are no static types that make the program execution successful.

Actually, both of the problems seems to be the inherent problems of gradual typing — if you hide too much information using $?$ types, the inference will not be able to give useful results. (Maybe that is why the authors choose a "dynamic inference" approach.) For the first problem, I don't think there are good solutions (maybe see papers by Castagna et al. recently for how they intersect the dynamic type with the static types to get more precise inference results) other than the approach of the second problem. For the second problem, I think the core of the erroneous example by the authors is that the static type system of their language is not strong enough: add union types and the problem will be solved for their example. Plus, I think the point of using dynamic types is, sometimes, to allow some programs that are not statically well-typed but are still "safe".

]
