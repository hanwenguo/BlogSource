#metadata((
  title: "Gödel's β Function",
  date: "2023-09-22T21:00:00+08:00",
  tags: ("math",),
))<frontmatter>

Today in the _Introduction to Recursion Theory_ course I was told about Gödel's β Function, which makes it possible to encode a finite sequence into a single natural number.

== The Definition

Before the function it self, there are some auxiliary functions that need to be defined.

First we come up with the quotient and remainder functions.
For all $m, n in omega$, let $"quo"(m, n)$ and $"rem"(m, n)$ be the quotient and remainder of $m$ divided by $n$, respectively, if $n != 0$, and $0$ otherwise.

Then follows the (floored) square root and exceedence functions. For all $n in omega$, let $lr([sqrt(n)])$ be the largest number $k$ that $k^2 <= n$, and $upright(K)(n) = n - lr([sqrt(n)])^2$.

Now comes the $upright(J)$ and $upright(L)$ functions, named after what Gödel named them. Let $upright(J)(m, n) = ((m + n)^2 + n)^2 + m$, and $upright(L)(n) = upright(K)(lr([sqrt(n)]))$. The definitions may seems weird at first glance, but they would soon show their power. And they have great properties: for all $m, n in omega$, $upright(K)(upright(J)(m, n)) = m$ and $upright(L)(upright(J)(m, n)) = n$. The proof goes as follows.

For that property of $upright(K)$ and $upright(J)$, it suffices to show that $lr([sqrt(upright(J)(m, n))]) = (m + n)^2 + n$, and this can be brought out by the fact that

$
((m+n)^2 + n + 1)^2 &= ((m + n)^2 + n)^2 + 2((m + n)^2 + n + 1) + 1^2 \
&> ((m + n)^2 + n)^2 + m.
$

That property of $upright(L)$ and $upright(J)$ is also easy following similar approach. These two properties means that the arguments of $upright(J)$ can be extracted from the result of it, and that means $upright(J)$ is an 1-1 function.

Finally, the Gödel's β function is defined by $beta(m, i) = "rem"(upright(K)(m), 1 + (i + 1) dot.c upright(L)(m))$. (Note that this is not the original definition (3-ary) but a simplified 2-ary one.) The definition is also a bit of complicated, but the following lemma tells us about why it is amazing.

== Gödel's β Function Lemma

For all $m_0, dots.h, m_(n - 1) in omega$, there exists a $m in omega$ such that
$
beta(m, i) = m_i
$
for all $i < n$.

And the the proof entails an algorithm to calculate such an $m$.

Before the proof, we need to prove two preliminary propositions.

=== Bézout's Lemma

#aside[Some out-of-topic mumbles: In my high school years, I had been thinking that this lemma was brought out by an ancient Chinese mathematician, since the name is translated as '裴蜀', which seems really like a Chinese name.]

(Note that this lemma is a weaken version of the original theorem.)

If $m, n in omega$ and they are coprime, then $a m + b n = 1$ for some **integers** $a$ and $b$.

Proof: Let $S = lr({ a m + b n divides a m + b n in omega })$, i.e. the set of all positive (integral) linear composition of $m$ and $n$. Thus there must be a minimum value $p in S$ for this non-empty set (the non-emptiness is trivial). What this proof wants to show is that $p = 1$. We prove this by contradiction. Assume that $p != 1$. Take $q in S$, let $r = "rem"(q, p)$, we have $0 <= r < p$. And $"rem"(q, p) in S$ since $p$ and $q$ are both (integral) linear composition of $m$ and $n$, so $"rem"(q, p)$ must be $0$, otherwise it contradicts with the minimality of $p$. Then we have $p divides q$ for all $q in S$. Note that $m in S$ and $n in S$, so $p$ is a common divisor of $m$ and $n$, which leads to the contradiction toward the coprimality of $m$ and $n$ if $p != 1$.

=== Chinese Remainder Theorem

For all $k_0, dots.h, k_(n-1) in omega$, if $d_0, dots.h, d_(n - 1) in omega$ are pairwise coprime and $k_i < d_i$ for all $i < n$, then there exists a $k in omega$ such that $"rem"(k, d_i) = k_i$ for all $i < n$.

Proof: For each $i < n$, let $m_i = (d_0 dots.c d_(n - 1))/(d_i)$. Since $d_0, dots.h, d_(n - 1)$ are pairwise coprime, $m_i$ and $d_i$ are coprime. By Bézout's Lemma, there are integers $a_i$ and $b_i$ such that $a_i m_i + b_i d_i = 1$. The insight here is that for each $d_i$, we construct the number that its remainder divided by $d_i$ is $k_i$, and compose these constructed numbers in a way that they won't affect each other. Note that $m_i$ cannot be divided by $d_i$, can be divided by $d_j$ for any $j < n$ where $j != i$, and there is an $1$ on the right hand side of the equation we got from the Bézout's Lemma. It is easy to see that, now it suffices to take
$
k = sum_(i < n) k_i a_i m_i + l d_0 dots.c d_(n - 1),
$
where $l$ is any natural number such that $k >= 0$.

=== The Proof of Gödel's β Function Lemma

Finally we come to the proof of the lemma. From the definition of $upright(J)$ and $beta$, we can see that we only need to find a proper value of $upright(L)(m)$ such that the numbers $1 + (i + 1) dot.c upright(L) (m)$ for each $i < n$ coprime, then construct the value of $upright(K)(m)$ by Chinese Remainder Theorem, and calculate the $m = upright(J)(upright(K)(m), upright(L)(m))$. For convenience, denote $1 + (i + 1) dot.c upright(L)(m)$ by $d_i$ for each $i < n$.

What conditions should the value of $upright(L)(m)$ satisfy? First, it must make $d_i = 1 + (i + 1) dot.c upright(L)(m) > m_i$, which is one of the conditions asked by Chinese Remainder Theorem. Second, it makes those $d_i$'s pairwise coprime. To prove propositions like 'there is _no_ prime $p$ such that $p divides d_i$ and $p divides d_j$ for different $i, j < n$', consider proof by contradiction. Think about what if there is some prime $p$ such that $p divides d_i$ and $p divides d_j$ for different $i, j < n$, i.e. $p divides 1 + (i + 1) dot.c upright(L) (m)$ and $p divides 1 + (j + 1) dot.c upright(L) (m)$. Assume $i < j$ without loss of generality, we have $p divides (j - i) dot.c upright(L)(m)$. It will be good if we have $p divides upright(L)(m)$, which would lead to the contradiction that $p divides 1$. So things become evident: find a construction of $upright(L)(m)$ such that $(j - i) divides upright(L)(m)$. This can be achived by making $upright(L)(m)$ divisible by the product of all the possible values of $j - i$, which ranges from $1$ to $n - 1$. This is to say, making $(n-1)! divides upright(L)(m)$ would be a good idea. With the first condition that $upright(L)(m)$ should satisfy, it suffices to take $upright(L)(m) = l!$, where $l = max{n, m_0, dots.h, m_(n - 1)}$. I take $n$ instead of $n - 1$ there for better elegance with the same effect.

The above is not a strictly stated proof, however it is easy to rewrite it into one.

== Mumbles (Again)

The reason I write this post is not that the ability of Gödel's β Function to encode a finite sequence into a number is amazing (there are many other techniques to achive this, e.g. encode the sequence into the exponents of an initial segment of primes), nor that the proof is elegant (though it is). It is just because I recalled the confusion that those two preliminary propositions caused to me, and realized that they seems easy for me now, and can be used to prove such lemmas. This feels strange, so I decided to write it down.
