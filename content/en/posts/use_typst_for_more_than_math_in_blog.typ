#metadata(
  (
    title: "Use Typst for More Than Math in Blog",
    date: "2025-02-27T23:30:00-07:00",
    tags: ("blog", "Typst"),
  )
)<frontmatter>

Last time I wrote about #link("/en/posts/use_typst_for_math_in_blog/")[using Typst for math in blog posts], where I expressed my wish for the day when Typst can be used for blog posts --- and today is the day! #link("https://typst.app/blog/2025/typst-0.13/#a-first-look-at-html-export")[Typst 0.13.0] has been released with the experimental HTML export feature. Also, #link("https://github.com/Myriad-Dreamin/typst.ts")[typst.ts] has been updated to support this feature. Thanks to the contribution of the Typst team and the community, I am able to do some tweaks and make Astro work with Typst to bring you this post.

If you are considering using Typst for your blog, here are some tips:
- check #link("https://github.com/typst-doc-cn/news")[this repo]: it is a successful example of using Typst and some glue scripts only to generate a static site;
- Hexo users: check out #link("https://github.com/Myriad-Dreamin/typst.ts")[typst.ts], which I think now provides HTML export in their Hexo plugin;
- Astro users: maybe I will share my setup after I clean up the mess, and for now, the above-menioned repo and #link("https://github.com/OverflowCat/astro-typst")[astro-typst] may be helpful. 