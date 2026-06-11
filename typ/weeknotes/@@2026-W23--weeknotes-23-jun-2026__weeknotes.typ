#import "/_template/template.typ": template, tr, ln, ct, inline-tree
#show: template(
  title:      [Weeknotes 23, Jun 2026],
  date:       datetime(year: 2026, month: 06, day: 02, hour: 20, minute: 42, second: 17),
  tags:       ("weeknotes",),
  identifier: "2026-W23",
)

#inline-tree(
  identifier: none,
  title: [Can we use type-cases instead of casts?],
  expanded: true,
  disable-numbering: false,
  level: 2,
)[
  Recently I was thinking whether we could simply use type-cases instead of casts for the runtime checks of gradual set-theoretic types. It seems to me that type casts in such a setting are almost just a limited form of type-cases.

  When studying gradual typing, we usually have a source language in which typechecking are implicitly loosened by the presence of gradual types, and terms of the source language is translated into a cast language where runtime typechecks are made explicit.

  But, in the set-theoretic setting we already have the type-case expression, and its very usage is to check the type of a value at runtime. So, why do we need another set of mechanism, namely casts, instead of using the more "native" type-cases?

  However, there are also some differences between them.

  First, a cast has a source type and a target type, where a type-case has only a test type which roughly corresponds to the target type, and the source type is implicitly the type of the testee.

  Second, they currently work differently for functions. Casts for functions are usually translated to a wrapper which inserts corresponding casts both for the argument and the return value, while type-cases usually only supports testing if something _is_ a function without caring details on the argument and return type.

  The last problem is, type-cases being more powerful and generic also means they are more complex. This in turn means replacing casts using type-cases may not make things more simple.
]
