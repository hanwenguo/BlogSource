#import "/_template/template.typ": ct, inline-tree, ln, template, tr
#show: template(
  title: [Weeknotes 33, Aug 2026],
  date: datetime(year: 2026, month: 08, day: 10, hour: 17, minute: 28, second: 24),
  tags: ("weeknotes",),
  identifier: "2026-W33",
)

#inline-tree(
  identifier: none,
  title: [Exact first-order checks for gradual typing?],
  expanded: true,
  disable-numbering: true,
)[

  #inline-tree(
    identifier: none,
    title: [My brief understanding of gradual typing],
    expanded: true,
    disable-numbering: true,
  )[
    One phrasing of the slogan of gradual typing is that "gradual typing is about ill-typed programs." (I heard this #ln("wb:2026-W21")[from Prof. David van Horn during NJPLS 2026].) But what does that mean? When do we need ill-typed programs?

    The famous slogan of type systems is that "well-typed programs do not go wrong." Obviously, we do not want wrong programs even though they are ill-typed. So, our hope is that the program _may_ go right under some circumstances, just that we cannot justify that to the type system.

    From this view, gradual typing means loosening the restrictions from the type system. For instance, we may write `x: ?` to indicate that `x` can be seen as anything; in a type system with subtyping, this is the same as down-casting the type of `x` to the bottom type, so it can be up-cast to any other type.

    Besides checking that the program may go right during loosened type checking, some versions of gradual typing also attempt to do better: in circumstances where the program does go wrong, try to make it go wrong in a controlled way. For example, instead of getting stuck, reaching some explicit error state that blames the reason sounds better. Such controlled wrongness is enforced by runtime checks.
  ]

  #inline-tree(
    identifier: none,
    title: [Runtime checks and safe erasure],
    expanded: true,
    disable-numbering: true,
  )[
    Now, one question is: what exactly should such runtime checks enforce? The answer of that question depends on what kinds of wrongness do we want to control.

    Recall that the goal of the static type system is to rule out certain kinds of stuck. Thus, the runtime checks should focus on the same kinds of stuck: when a value passes the runtime check, using it in certain contexts will reduce instead of stuck.

    It is very intuitive to come up with a inverse criterion: when using a value in certain contexts will not stuck, it should pass the runtime check. The criterion of #ln("wb:JTTT25")[robust dynamic embedding] captures this: if a dynamic term has the semantics of a certain static type, then only the context surrounding it but not the term itself should be blamed if using the term as that type produces an error.

    As stated above, the loosened static obligations are reassured by the runtime checks. Therefore, from this view, it would be absurd if the static obligations themselves are detached from runtime checks. The best view of static types then should be based on the runtime checks.
  ]

  #inline-tree(
    identifier: none,
    title: [Safe erasure],
    expanded: true,
    disable-numbering: true,
  )[
    Specifically, one interesting case is when we are working with a language that _already performs runtime type checks_. Not just runtime checks, but runtime _type_ checks. As an instance, Python raises `TypeError` when the type of things do not match.

    For those languages, a natural question then is that can we reuse these already-present checks for gradual typing? This idea is called #ln("wb:CD24")[Safe Erasure Gradual Typing]: although the elaboration is merely erasing type annotations, a well-typed term still either 1) diverges, 2) reduces to a so-typed value, or 3) triggers an error at a runtime check already present in the dynamic language.

    But what does safe erasure mean, after all? From the intuition, we can understand safe erasure as: the guarantees provided by the types are still sound because of existing runtime checks.

    For a function, the inferred function parameters must be over-approximations of their uses in the function body, because otherwise the type would include less values than what would be accepted, which in turn implies more checks than actual, so it would be unsafe to erase.

    On the other hand, the inferred function return types are also over-approximations of what would actually be returned, otherwise it would be also unsafe to erase that type because there are no real checks for return types.

    What about annotated types? One caveat is that types are not strict anymore. By not being strict I mean that, for example, the return value of a function with type `A -> B` might not be `B`. Only _strong_ functions have such property; ordinary functions, when passed a value with the unknown type, only returns an unknown.

    This landscape deliberately leaves the other direction open, i.e. under-approximation of function parameter type and under-approximation or function return type.
  ]

  If we try to view static types as abstractions of runtime checks, one immediate problem is how to treat higher-order types like function types. A function type cannot be an abstraction of runtime checks, because there are no general way to check if a function has a certain function type (in the usual understanding, returning something in the range type if provided something in the domain type) without calling it.

  On the contrary, there are other type constructors that I call first-order, and they should have the property that a type containing only first-order type constructors is an exact abstraction of a set of runtime checks.

  #ln("wb:CD24")[Safe Erasure Gradual Typing] proposes _strong functions_ to deal with function types. A strong function, when called with an arbitrary dynamic argument, can only return a value within its codomain, diverge, or fail through an existing runtime check.
]
