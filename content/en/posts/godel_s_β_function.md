---
title: "Gödel's β Function"
date: 2023-09-22T21:00:00+08:00
enableMath: true
tags: ["math"]
---

Today in the _Introduction to Recursion Theory_ course I was told about Gödel's β Function, which makes it possible to encode a finite sequence into a single natural number.


## The definition

Before the function it self, there are some auxiliary functions that need to be defined.

First we come up with the quotient and remainder functions.
For all \\(m, n \in \omega\\), let \\(\textrm{quo}(m, n)\\) and \\(\textrm{rem}(m, n)\\) be the quotient and remainder of \\(m\\) divided by \\(n\\), respectively, if \\(n \neq 0\\), and \\(0\\) otherwise.

Then follows the (floored) square root and exceedence functions. For all \\(n \in \omega\\), let \\(\left[\sqrt{n}\right]\\) be the largest number \\(k\\) that \\(k^2 \le n\\), and \\(\textrm{K}(n) = n - \left[\sqrt{n}\right]^2\\).

Now comes the \\(\textrm{J}\\) and \\(\textrm{L}\\) functions, named after what Gödel named them. Let \\(\textrm{J}(m, n) = ((m + n)^2 + n)^2 + m\\), and \\(\textrm{L}(n) = \textrm{K}(\left[\sqrt{n}\right])\\). The definitions may seems weird at first glance, but they would soon show their power. And they have great properties: for all \\(m, n \in \omega\\), \\(\textrm{K}(\textrm{J}(m, n)) = m\\) and \\(\textrm{L}(\textrm{J}(m, n)) = n\\). The proof goes as follows.

For that property of \\(\textrm{K}\\) and \\(\textrm{J}\\), it suffices to show that \\(\left[\sqrt{\textrm{J}(m, n)}\right] = (m + n)^2 + n\\), and this can be brought out by the fact that

\begin{align}
((m+n)^2 + n + 1)^2 &= ((m + n)^2 + n)^2 + 2((m + n)^2 + n + 1) + 1^2 \\\\
&> ((m + n)^2 + n)^2 + m
\end{align}

.
That property of \\(\textrm{L}\\) and \\(\textrm{J}\\) is also easy following similar approach. These two properties means that the arguments of \\(\textrm{J}\\) can be extracted from the result of it, and that means \\(\textrm{J}\\) is an 1-1 function.

Finally, the Gödel's β function is defined by \\(\beta(m, i) = \textrm{rem}(\textrm{K}(m), 1 + (i + 1) \cdot \textrm{L}(m))\\). (Note that this is not the original definition (3-ary) but a simplified 2-ary one.) The definition is also a bit of complicated, but the following lemma tells us about why it is amazing.


## Gödel's β Function Lemma

For all \\(m\_0, \dots, m\_{n - 1} \in \omega\\), there exists a \\(m \in \omega\\) such that
\\[\beta(m, i) = m\_i\\]
for all \\(i < n\\).

And the the proof entails an algorithm to calculate such an \\(m\\).

Before the proof, we need to prove two preliminary propositions.


### Bézout's Lemma

(Some out-of-topic mumbles: In my high school years, I had been thinking that this lemma was brought out by an ancient Chinese mathematician, since the name is translated as '裴蜀', which seems really like a Chinese name.)

(Note that this lemma is a weaken version of the original theorem.)

If \\(m, n \in \omega\\) and they are coprime, then \\(am + bn = 1\\) for some **integers** \\(a\\) and \\(b\\).

Proof: Let \\(S = \left\\{ am + bn \mid am + bn \in \omega \right\\}\\), i.e. the set of all positive (integral) linear composition of \\(m\\) and \\(n\\). Thus there must be a minimum value \\(p \in S\\) for this non-empty set (the non-emptiness is trivial). What this proof wants to show is that \\(p = 1\\). We prove this by contradiction. Assume that \\(p \not = 1\\). Take \\(q \in S\\), let \\(r = \textrm{rem}(q, p)\\), we have \\(0 \le r < p\\). And \\(\textrm{rem}(q, p) \in S\\) since \\(p\\) and \\(q\\) are both (integral) linear composition of \\(m\\) and \\(n\\), so \\(\textrm{rem}(q, p)\\) must be \\(0\\), otherwise it contradicts with the minimality of \\(p\\). Then we have \\(p \mid q\\) for all \\(q \in S\\). Note that \\(m \in S\\) and \\(n \in S\\), so \\(p\\) is a common divisor of \\(m\\) and \\(n\\), which leads to the contradiction toward the coprimality of \\(m\\) and \\(n\\) if \\(p \not = 1\\).


### Chinese Remainder Theorem

For all \\(k\_0, \dots, k\_{n-1} \in \omega\\), if \\(d\_0, \dots, d\_{n - 1} \in \omega\\) are pairwise coprime and \\(k\_i < d\_i\\) for all \\(i < n\\), then there exists a \\(k \in \omega\\) such that \\(\textrm{rem}(k, d\_i) = k\_i\\) for all \\(i < n\\).

Proof: For each \\(i < n\\), let \\(m\_i = \frac{d\_0 \cdots d\_{n - 1}}{d\_i}\\). Since \\(d\_0, \dots, d\_{n - 1}\\) are pairwise coprime, \\(m\_i\\) and \\(d\_i\\) are coprime. By Bézout's Lemma, there are integers \\(a\_i\\) and \\(b\_i\\) such that \\(a\_i m\_i + b\_i d\_i = 1\\). The insight here is that for each \\(d\_i\\), we construct the number that its remainder divided by \\(d\_i\\) is \\(k\_i\\), and compose these constructed numbers in a way that they won't affect each other. Note that \\(m\_i\\) cannot be divided by \\(d\_i\\), can be divided by \\(d\_j\\) for any \\(j < n\\) where \\(j \not = i\\), and there is an \\(1\\) on the right hand side of the equation we got from the Bézout's Lemma. It is easy to see that, now it suffices to take
\\[k = \sum\_{i < n} k\_i a\_i m\_i + l d\_0 \dots d\_{n - 1}\\], where \\(l\\) is any natural number such that \\(k \ge 0\\).


### The proof fo Gödel's β Function Lemma

Finally we come to the proof of the lemma. From the definition of \\(\textrm{J}\\) and \\(\beta\\), we can see that we only need to find a proper value of \\(\textrm{L}(m)\\) such that the numbers \\(1 + (i + 1) \cdot \textrm{L} (m)\\) for each \\(i < n\\) coprime, then construct the value of \\(\textrm{K}(m)\\) by Chinese Remainder Theorem, and calculate the \\(m = \textrm{J}(\textrm{K}(m), \textrm{L}(m))\\). For convenience, denote \\(1 + (i + 1) \cdot \textrm{L}(m)\\) by \\(d\_i\\) for each \\(i < n\\).

What conditions should the value of \\(\textrm{L}(m)\\) satisfy? First, it must make \\(d\_i = 1 + (i + 1) \cdot \textrm{L}(m) > m\_i\\), which is one of the conditions asked by Chinese Remainder Theorem. Second, it makes those \\(d\_i\\)'s pairwise coprime. To prove propositions like 'there is _no_ prime \\(p\\) such that \\(p \mid d\_i\\) and \\(p \mid d\_j\\) for different \\(i, j <n\\)', consider proof by contradiction. Think about what if there is some prime \\(p\\) such that \\(p \mid d\_i\\) and \\(p \mid d\_j\\) for different \\(i, j <n\\), i.e. \\(p \mid 1 + (i + 1) \cdot \textrm{L} (m)\\) and \\(p \mid 1 + (j + 1) \cdot \textrm{L} (m)\\). Assume \\(i < j\\) without loss of generality, we have \\(p \mid (j - i) \cdot \textrm{L}(m)\\). It will be good if we have \\(p \mid \textrm{L}(m)\\), which would lead to the contradiction that \\(p \mid 1\\). So things become evident: find a construction of \\(\textrm{L}(m)\\) such that \\((j - i) \mid \textrm{L}(m)\\). This can be achived by making \\(\textrm{L}(m)\\) divisible by the product of all the possible values of \\(j - i\\), which ranges from \\(1\\) to \\(n - 1\\). This is to say, making \\((n-1)! \mid \textrm{L}(m)\\) would be a good idea. With the first condition that \\(\textrm{L}(m)\\) should satisfy, it suffices to take \\(\textrm{L}(m) = l!\\), where \\(l = \max\\{n, m\_0, \dots, m\_{n - 1}\\}\\). I take \\(n\\) instead of \\(n - 1\\) there for better elegance with the same effect.

The above is not a strictly stated proof, however it is easy to rewrite it into one.


## Mumbles (Again)

The reason I write this post is not that the ability of Gödel's β Function to encode a finite sequence into a number is amazing (there are many other techniques to achive this, e.g. encode the sequence into the exponents of an initial segment of primes), nor that the proof is elegant (though it is). It is just because I recalled the confusion that those two preliminary propositions caused to me, and realized that they seems easy for me now, and can be used to prove such lemmas. This feels strange, so I decided to write it down.
