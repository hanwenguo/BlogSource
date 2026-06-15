#import "/_template/template.typ": template, tr, ln, ct, inline-tree
#show: template(
  title:      [Weeknotes 24, Jun 2026],
  date:       datetime(year: 2026, month: 06, day: 10, hour: 18, minute: 19, second: 54),
  tags:       ("weeknotes",),
  identifier: "2026-W24",
)

#inline-tree(
  identifier: none,
  title: [Semantic subtyping for functions],
  expanded: true,
  disable-numbering: true,
)[
  Dealing with functions in a semantic subtyping setting is awkward: it is generally not viable to use type-case to test with function types. For example, you cannot say "test if $x$ is type $t_1 -> t_2$."

  The reason is that, functions don't have "principal" or "minimal" types in general. That is, for a function value $f$, it is not guaranteed that there is a type $t_f$ such that for any type $t$, either $t_f <: t$ or $t_f <: not t$. For instance, consider the identity function. Its principal type $t_"id"$ should be $inter.big_t (t -> t)$ for all type $t$, but that is not expressible in an ordinary type system.

  #footnote[
    The core reason might be that functions are expressing calculations that depends on the input. This might in turn be reflected in the typing rules for functions: the type context $Gamma$ is different above and below the line.

    I also have a sense that this is due to the possibly infinite input space of functions. If you restrict the domain to finite types, for example no $top$ could occur in the type of things, then we might be able to deduce a principal type.

    What if we have parametric polymorphism? But it could make things worse.
  ]

  In general, to test whether $f$ has type $t_1 -> t_2$ is to ask if for every value $x$ in $t_1$, $f(x)$ is in $t_2$. If there is a principal type $t_f$, then we should be able to get, informally, the restriction of $t_f$ to $t_1$. That requires the domain of $t_f$ to be able to be split into minimal types, along with also split range. Still consider the identity function: since there are no infinite intersection type, we can only type it as $top -> top$, and we have no idea what the corresponding range should be for the split domains.

  One might ask how do we typecheck a function then. Turns out we are totally fine in typechecking stage, but this is about how to check the type of a function dynamically at runtime, and if we want to call the typechecker at runtime, we will have to introduce a lot of other problems. Maybe using abstract interpretation to execute the function on the abstract domain could help?
]
