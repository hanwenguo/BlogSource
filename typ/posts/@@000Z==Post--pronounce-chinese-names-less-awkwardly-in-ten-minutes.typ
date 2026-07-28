#import "/_template/template.typ": template, tr, ln, ct, inline-tree
#show: template(
  title:      [Pronounce Chinese Names Less Awkwardly in Ten Minutes],
  date:       datetime(year: 2026, month: 07, day: 27, hour: 21, minute: 17, second: 58),
  tags:       (),
  identifier: "000Z",
  taxon:  "Post",
)

Some Chinese names can be hard to pronounce for English speakers, especially those containing, to name a few, "X", "Q", "Zh", and so on.

The goal of this post is not to teach you the _right_ or _perfect_ pronunciation. That takes some dedicated time and effort. So, it will not talk about the standard pronunciation for most phonemes nor the tone. Rather, it tries to get you close enough that when you call out a Chinese name for an order or class attendance, they know you are calling them.

Note that, if you want to learn the right pronunciation rather than rough approximations from the very beginning (so that you do not need to correct yourself if you then decide to learn Chinese seriously), #link("https://en.wikipedia.org/wiki/Pinyin")[the Wikipedia article] and online videos can be more helpful.

#inline-tree(
  identifier: none,
  title: [Some background],
  expanded: false,
  disable-numbering: false,
)[
  Chinese has its own writing system, known as Hanzi or Chinese characters. So, what English speakers usually deal with are the _romanization_ of the names, that is, their pronunciation transcribed using the Latin alphabet.

  While there used to be several romanization systems for Chinese, Pinyin is now the most popular one and is also the standard for Chinese transliteration in most Chinese-speaking regions. This post only talks about Pinyin. Other romanization systems, which may be used in historical names, are also easier to pronounce for English speakers.

  Also, there are a lot of dialects of Chinese besides Standard Chinese (Putonghua) and their pronunciation can be very different from the latter. This post only talks about the standard one.
]

#inline-tree(
  identifier: none,
  title: [The alphabet],
  expanded: true,
  disable-numbering: false,
)[
  The more correct terms here is _initials_ and _finals_ in syllables, but to simplify, this post just says _consonants_ and _vowels_ in syllables, which is technically not correct (just like other parts of this post).

  #inline-tree(
    identifier: none,
    title: [Consonants],
    expanded: true,
    disable-numbering: false,
  )[
    The consonants of Chinese Pinyin are:

    ```
  b  p  m  f  d  t  n  l  g  k  h  j  q  x  zh  ch  sh  r  z  c  s  y  w
    ```

    The ones that are usually pronounced completely unrecognizably are `q`, `x`, `c` and `zh`. For a likely recognizable simulation:
    - pronounce `q` like "ch" as in "cheers",
    - pronounce `x` like "sh" as in "push",
    - pronounce `c` like "ts" as in "tsunami",
    - pronounce `zh` like "j" as in "june".

    Most other consonants sound recognizable when pronounced following the English rules. An exception is `y`, which is explained in the following subsections.
  ]

  #inline-tree(
    identifier: none,
    title: [Vowels],
    expanded: true,
    disable-numbering: false,
  )[
    There are non-compound and compound vowels, and the _actual_ pronunciation of the compound ones are usually _not_ simply saying the non-compound ones in sequence. However, this post tries to make things easier by telling you how to pronounce the non-compound ones and simply pronounce them in sequence for compound ones.

    The non-compound vowels are:

    ```
    a o e i u ü
    ```

    `ü` is the hardest one, so we go with that first, because you cannot be too wrong with other vowels but can be completely wrong with that, for the reason that no phonemes in English sound even remotely like it. If you also speak German or French, it is the same sound as the "ü" in "über" in German or "u" in "tu", "juge" or "su" in French. To describe it directly, it is the sound when your tongue is at the same position as when saying "ee" in "bee" but your lips are round like when saying "oo" in "foo".

    Among the other non-compound vowels, `a` can be simulated by one single sound no matter where it appears: pronounce `a` like in "father", not like in "bad". The rest each have their caveats.

    `i` can be pronounced as "ee" like in "need" most of the time. The exceptions are when it follows `z`, `c`, `s`, `zh`, `ch`, `sh` and `r`: in those cases, quoting from Wikipedia, it is "a buzzed continuation of the consonant." That is, after you have pronounced the consonants, do not move your lips or tongue while keeping your vocal cords vibrating.

    #footnote[For `u`, the caveat is, when the letter `u` appears after `j`, `q`, `x` and `y`, it actually represents the vowel `ü` with the #link("https://en.wikipedia.org/wiki/Umlaut_(diacritic)")[umlaut] omitted. So, for example, `ju` is actually pronounced as `jü`, and `xuan` is actually pronounced as `xüan`.]`u` itself can also be almost always simulated by one single pronunciation: as "oo" in "food".

    For `e`, always pronouncing it as the schwa, i.e. like "a" in "ago" or the "uhh" sound you make when hesitating, is close enough, although not as close as the other vowels described as "close enough" above. If you want to sound a bit more correct, in `ie` and `üe` it should be pronounced as a sound that is in the middle of "e" in "bet" and "i" in "bid". For example, `ie` sounds like reversed "ey" in "hey".

    #footnote[The exceptions for `o` are when it appears alone in `bo`, `po`, `mo`, `fo` and `wo`, and in these cases it is an abbreviation of the compound vowel `uo`.]`o` usually appears with other vowels, and can also be simulated by a single sound. For North American English speakers, pronounce it like "ough" in "thought". For British English speakers, pronounce it like "augh" in "caught" or "o" in "office".

    #inline-tree(
      identifier: none,
      title: [Compound Vowels],
      expanded: true,
      disable-numbering: false,
    )[
      For the compound vowels like `ao`, `ou`, `ian` and so on, pronouncing their consisting non-compound vowels will make it likely recognizable.

      Three exception are `iu`, `ui` and `un`. These are actually abbreviations: `iu` expands to `iou`, `ui` expands to `uei`, `un` expands to `uen`.
    ]

    #inline-tree(
      identifier: none,
      title: [More caveats about ü],
      expanded: true,
      disable-numbering: false,
    )[
      The first is when it follows `y`. As stated above, the consonant `y` is not always pronounced like "y" in English, and the cases where it is not are `yu` combinations, which represents the semivowel corresponding to `ü` just like how the usual `y` corresponds to `i` and `w` corresponds to `u`.

      The second is about the transliteration of `ü`. Since `ü` is not in the English alphabet, the vowel `ü` needs to be represented differently when transliterating to English. Thanks to the rule mentioned above that `ü` is written as `u` in a lot of places, the only places where `ü` really appears are following `l` and `n`, such as `lü` or `nüe`. And among these places, the only two that require particular treatment during the transliteration is `lü` and `nü`. In names, they are usually transliterated as `lv`/`nv` casually (like in daily typing) or `lyu`/`nyu` officially (like on passports), and sometimes (unfortunately), the ambiguous `lu`/`nu`.
    ]
  ]
]

#inline-tree(
  identifier: none,
  title: [Examples],
  expanded: true,
  disable-numbering: false,
)[
  It is time for practice now. For example, my name --- Hanwen Guo --- should be rather simple to pronounce then. To test yourself, put the Chinese characters below into some TTS software and compare your pronunciation of the transliterated names with its (these names are from Jin Yong's Wuxia novels):
  - Xiao Feng 萧峰
  - Qiu Chuji 丘处机
  - Yelü Qi 耶律齐
  - Xiaolongnü 小龙女
  - Zhang Junbao 张君宝
  - Zhou Zhiruo 周芷若
  - Yue Buqun 岳不群
]
