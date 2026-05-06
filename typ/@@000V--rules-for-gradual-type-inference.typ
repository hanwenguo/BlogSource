#import "/_template/template.typ": template, tr, ln, ct, inline-tree
#show: template(
  title:      [Rules for gradual type inference],
  date:       datetime(year: 2026, month: 04, day: 21, hour: 22, minute: 27, second: 28),
  tags:       (),
  identifier: "000V",
)

In section 3 of #ln("wb:sv-GradualTypingUnificationbased-2008")[Gradual Typing with Unification-based Inference], the authors discuss some examples where the naive "well-typed after substitution" approach fails. That implies some rules that gradual type inference should follow.

In the following example codes, `α` is a type variable not in the parametric polymorphism sense, but in the unification-based type inference sense, that is, a variable to be substituted with a gradual type after type inference.

#inline-tree(
  title: "Static conservativity",
  level: 2
)[
```
let f(g: α) = g 1
f 1
```

  The above program would not pass static typecheck, since there is no possible substitution for `α`. Thus, even if substituting `α` with `?` make the program pass gradual typecheck, such a substitution should not be chosen.

  The rule here is that a program can be gradually well-typed if and only if it can be statically well-typed.
]

#inline-tree(
  title: "Constraint-informativeness preservation",
  level: 2
)[
```
let x: α = x + 1
```

  Substituting `α` with `?` would make the above program pass gradual typecheck, but a more appropriate choice is `int`.

  The rule here is that when a more precise type is possible, a less precise one should not be chosen as the inferred type.
]

#inline-tree(
  title: "Minimal adequate solution",
  level: 2
)[
```
let f(x: ?) =
    let y: α = x in y
```

  Substituting `α` with some more precise type such as `int` won't trigger a type error during gradual typecheck, since they are consistent with `?`. However, doing so blocks the possibility to, for example, apply the function to a boolean. The only appropriate substitution for `α` is `?`.

  The rule here is that when multiple types all make the program gradually well-typed, then the chosen type should be less precise than them and be consistent with them, that is, they are all materializations of the chosen type.
]
