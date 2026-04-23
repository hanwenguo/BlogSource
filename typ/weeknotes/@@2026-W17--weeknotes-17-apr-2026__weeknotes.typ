#import "/_template/template.typ": template, tr, ln, ct, inline-tree
#show: template(
  title:      [Weeknotes 17, Apr 2026],
  date:       datetime(year: 2026, month: 04, day: 21, hour: 21, minute: 43, second: 48),
  tags:       ("weeknotes",),
  identifier: "2026-W17",
)

This week I have been thinking about the problem of choosing a "best" or "principal" type when performing gradual type inference.

#inline-tree(
  identifier: none,
  title: [Principal type for gradual type inference],
  expanded: true,
  disable-numbering: true,
  level: 2,
)[
  The type inference problem can be described as, given a context $Gamma$ and an expression $e$, find a type $T$ such that $Gamma tack e : T$.

  The problem is that, there could be multiple types $T$ that is _valid_ in some sense. For example, a function $lambda x . space x$ satisfies both the type $sans("Int") arrow sans("Int")$ and $sans("Bool") arrow sans("Bool")$ intuitively.

  In such cases, we want to infer a principal type (I'm using the term "principal" in a loose and informal sense). For example, for the identity function above, we might want to infer something like $forall alpha . space alpha arrow alpha$ which could be instantiated to the two concrete types.

  Here is another example:
```
class Animal():
  field name :: String

class Cat():
  extends Animal
  field fishes

class Dog():
  extends Animal
  field bones
```
  Given the code above, a function `fun (x): x.name` might have type `Cat -> String`, `Dog -> String`, or even `Animal -> Object`. but a more suitable type would be `Animal -> String`. So, for different type systems, how we define the property of being "principal" can vary. For a system with parametric polymorphism, it might mean being able to be instantiated to any other possible type; for a system with subtyping, it might mean being the supertype of any other possible type without going too far to the top type like `Object` unless necessary. In one word, the type we want is principal with regard to a certain relation.

  Now let's consider the type inference for a gradual type system. Still, there could be multiple types that are valid in some sense, and we want to pick a principal one. The problem now is:
  1. What does "valid" mean?
  2. What does "principal" mean?

  Validity can have many interpretations. It could mean _static typability_, that is, plugging in a valid type yields a gradually well-typed program. For a unification-based type inference system, that means satisfying all the constraints. It may also concern runtime semantics, such as requiring that after plugging in the inferred type, all executions or at least some executions are safe (no cast error, do not diverge, etc.). For our analysis now, let's choose the typing-based interpretation, that is, it should at least mean not raising a static type error when plugged in.

  What about being principal? Intuitively, just like in systems with subtyping we pick the type satisfying certain properties with regard to the subtyping relation, in a gradual type system we should pick the type with certain properties with regard to the _precision_ or _materialization_ relation. Also like subtyping, the precision or materialization relation induces a #link("https://en.wikipedia.org/wiki/Semilattice")[upper semilattice] on the gradual types. So, the problem becomes: given a set $T$ of members of the semilattice $chevron.l S, <= chevron.r$ where all $t in T$ satisfies the validity condition $V(t)$, pick a $t in T$ satisfying certain properties. Here the relation $a <= b$ means $a$ is more precise than $b$, or $a$ materializes $b$. Note that with that relation and our typability interpretation of validity, $V(t)$ has the monotone property: if $V(t_1)$ and $t_1 <= t_2$, then also $V(t_2)$.

  As a hint, we could try to extract some rules from previous literature (notice that the direction of the order relation $subset.eq.sq$ in the literature is the reverse of our $<=$):

  #tr("wb:000V", expanded: false, disable-numbering: true, demote-headings: 2)

  The first rule is more connected to the #ln("wb:svcb-RefinedCriteriaGradual-2015")[Refined Criteria for Gradual Typing]: it simply says that if there are no static types in $T$, then we should raise a type error. It implies that $T$ has some minimal element(s), i.e. elements that no other elements are smaller than them (different from the least element), and they are all static types since minimal elements that are not static types cannot be in $T$ according to rule 1.

  #let t_top = $sigma_sans("glb")$

  The second rule is more like filtering what is "valid": from the constraints we know that there is a set $Sigma subset.eq S$ such that for all $t in T$ and for all $sigma in Sigma$, $sigma$ is less precise than $t$. For our specific inference problem to be meaningful, a reasonable requirement is that there exist a lower bound of all $sigma in Sigma$ with regard to $<=$; otherwise we won't have a reasonable element to choose as the principal one. That implies that a greatest lower bound #t_top of $Sigma$ exists, and it is an upper bound of what we might choose as the principal type. From the perspective of types, all the $sigma$s means some information we already know about the type to infer, and their greatest lower bound is the combination of these informations. For example, we may have $Sigma = {"?" -> (sans("Int") -> "?"), "?" -> ("?" -> sans("Int"))}$, and $#t_top = "?" -> (sans("Int") -> sans("Int"))$.

  #let t_bot = $accent(t, breve)$

  The third rule makes more sense of "principal." It implies that if the greatest lower bound of $T$ does not exist or is not in $T$ (i.e. $T$ does not have a least element), then the principal element we choose should be greater than or equal to the least upper bound #t_bot of the minimal elements of $T$. This #t_bot sets a lower bound of what we might choose as the principal type. Notice that the minimal elements of $T$ at least contains some static types (implied by rule 1), and any pair of static types are non-comparable, and any static type is also a minimal element in $chevron.l S, <= chevron.r$, so if the greatest lower bound of $T$ exists and is in $T$, then that element must be the sole static type in $T$. If that is the case, intuitively this static type should just be the principal type we infer.

  The third rule and second rule combined together gives us another requirement: #t_bot should be less than or equal to #t_top. Otherwise we have no reasonable $t$ to choose as the principal one. It is also clear that when the two are equal and they are in $T$, they are the principal element to choose.

  Are #t_top and #t_bot in $T$? To answer this, we first ask: in what cases would a type be not in $T$? Since our notion of "valid" means "not raising type error when plugged in", then not in $T$, i.e. not valid, should mean it would raise a type error when plugged in, which in turn means that all the materialization of it (thus all static ones) would raise a type error. So, "valid" in turn means some of its materialization (thus some static ones) would fit. This interpretation immediately tells us that $#t_top in T$ and $#t_bot in T$.

  Since $#t_top in T$ and $#t_bot in T$, let $T' subset.eq T$ be the set of all elements in $T$ that is between them, $chevron.l T, <= chevron.r$  form a lattice; more precisely, a sub-lattice of $chevron.l S, <= chevron.r$. The next question is: how should we choose the principal type out of it?

  If $T'$ is a singleton, the answer is very simple. In what cases would $T'$ not be a singleton? That would be the cases where there are materialization of #t_top other than #t_bot that would raise a type error when plugged in. What should we choose as the principal type in that case?

  The answer is still not clear to me, but I doubt that it would be more like a design choice. If you want to be more tolerant and allow more things to be consistent, you choose $#t_top$; if you want to be more precise, you choose $#t_bot$.

  From the view of abstract interpretation, every gradual type $tau$ can be concretized to a set of static types $gamma(tau)$, and every set of static types ${t, ...}$ can be abstracted to a gradual type $alpha({t, ...})$. Obviously, $#t_top = alpha(union.big_(space.thin t in T) gamma(t))$, and $#t_bot = alpha(inter.big_(space.thin t in T) gamma(t))$.

  Also note that this concept of being principal could be somehow orthogonal to other concepts of principal type, such as the subtyping or parametric polymorphism ones we mentioned above. If that is the case, the type inference algorithm need to consider all of them and maybe make some considerations if they are not compatible.
]
