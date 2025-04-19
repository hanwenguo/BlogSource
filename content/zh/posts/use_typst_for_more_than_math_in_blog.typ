#metadata((
  title: "使用 Typst 渲染博客，不止数学公式",
  date: "2025-02-27T23:30:00-07:00",
  tags: ("博客", "Typst"),
))<frontmatter>

之前我写过一篇关于 #link("/zh/posts/use_typst_for_math_in_blog/")[使用 Typst 渲染博客中的数学公式] 的文章，表达了希望 Typst 能够用于整篇文章而不仅是数学公式的愿望，而这一天终于到来了！#link("https://typst.app/blog/2025/typst-0.13/#a-first-look-at-html-export")[Typst 0.13.0] 已经发布了实验性的 HTML 导出功能。此外，#link("https://github.com/Myriad-Dreamin/typst.ts")[typst.ts] 也进行了更新，以支持这一功能。多亏 Typst 团队和社区，才能让我只为自己的博客做一些小改动，就能使用 Typst 来渲染整篇文章——这篇文章就是一个例子。

如果你正在考虑使用 Typst 来渲染你的博客，这里有一些建议：
- 查看 #link("https://github.com/typst-doc-cn/news")[这个仓库]：这个例子展示了如何仅使用 Typst 和一些脚本来生成静态网站；
- Hexo 用户：查看 #link("https://github.com/Myriad-Dreamin/typst.ts")[typst.ts]，现在其 Hexo 插件中提供了 HTML 导出功能；
- Astro 用户：也许我之后会分享我的配置，目前上面提到的仓库和 #link("https://github.com/OverflowCat/astro-typst")[astro-typst] 可能会有所帮助。