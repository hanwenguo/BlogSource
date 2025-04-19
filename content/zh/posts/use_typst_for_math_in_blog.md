---
title: "使用 Typst 渲染博客中的数学公式"
date: 2025-01-12T12:47:00-07:00
tags: ["博客", "Typst"]
---

我刚刚将博客中的数学公式渲染方法从 MathJax 换成了 Typst。

如果你还不知道 [Typst](https://typst.app/docs/) 是什么，它是一个相对较新的排版系统。目前来说，它还没办法在所有场景下代替 LaTeX，但对于大部分人日常所需要排版的大部分文档来说，它已经够用并且好用。此外，还有一个名为 [typst.ts](https://github.com/Myriad-Dreamin/typst.ts) 的 JavaScript 库，通过嵌入 WASM 版本的 Typst 引擎，让我们可以在浏览器或 Node.js 等 JavaScript 环境中使用 Typst 的大部分功能。

从 MathJax 换成 Typst 有以下优点：

- 无需客户端渲染，因为数学公式是在页面构建时被编译成 SVG；
- 少了一个需要加载的 JavaScript 库；
- 可以使用 Typst 的完整数学语法，相比而言，MathJax 仅支持 LaTeX 数学语法的一个子集。

当然也有一些缺点：

- 对辅助功能不够友好，因为数学公式都被渲染成了 SVG；不过，生成的 SVG 图像中似乎有文本内容，所以屏幕阅读器也许可以读出公式内容，但我还没有测试过；
- 与 LaTeX 不同的语法（我认为这是一个优点，但迁移旧文章可能会有些不便）；
- 与各种站点构建工具集成起来不是那么方便，但这对我来说不是问题（见下一节）。

你可以在[这篇文章](/zh/posts/godel_s_β_function/)中看到一些例子。（更新于 2025/04/19：该篇文章现在完全用 Typst 渲染，所以其数学公式的样式不再体现下面的方法给出的效果。）

## 集成

[typst.ts](https://github.com/Myriad-Dreamin/typst.ts) 提供了一个 Hexo 渲染器插件和一个 rehype 插件。我的博客现在是用 Astro 构建的，所以只需要在 Astro 配置文件中添加一个新的 rehype 插件即可：

```javascript
import remarkMath from 'remark-math';
import rehypeTypst from '@myriaddreamin/rehype-typst';

export default defineConfig({
  markdown: {
    remarkPlugins: [remarkMath],
    rehypePlugins: [rehypeTypst]
  },
})
```

然后在 Markdown 文件中用美元符号包裹的公式将由 Typst 渲染。

不过，与其他非 JavaScript 的站点构建工具集成起来可能会有些复杂。

### 修复深色模式下的问题

一个问题是渲染出的 SVG 图的默认前景色是黑色，在深色模式下看不清楚。为 SVG 图像添加 CSS filter 可以解决这个问题：

```css
@media (prefers-color-scheme: dark) {
  svg.typst-doc {
    filter: invert(100%) sepia(0%) saturate(367%) hue-rotate(19deg) brightness(105%) contrast(101%);
  }
}
```

上面的 CSS filter 把 SVG 图像的颜色更改为 `#ffffff`，这是这个博客中深色模式下的文本颜色。
这段 CSS filter 是[这个 StackOverflow 回答](https://stackoverflow.com/questions/22252472/how-can-i-change-the-color-of-an-svg-element#answer-53336754)中提到的[这个 Codepen 项目](https://codepen.io/sosuke/pen/Pjoqqp)生成的。

### 修复行高问题

另一个问题是 SVG 图像的行高与文本不一致。typst.ts 生成的 SVG 图像具有特定的高度，略大于博客中 `<p>` 元素的 `line-height`。这导致了带有数学公式的段落的行高大于没有数学公式的段落，看起来很丑。

这个问题的难点在于这些 SVG 图像的 `height` 和 `width` 属性是由 typst.ts 设置的，并且 rehype-typst 没有提供修改渲染方式的配置选项，所以我必须找到一种不修改 SVG 图像本身的方法。

最终的解决方案有点取巧：

- 稍微增加 `<p>` 元素的 `line-height`（从 `1.5` 到 `1.6`）；
- 手动将 SVG 图像的 `font-size` 设置为 `16px`，相比而言， `<body>` 的 `font-size` 是 `18px`。

这样，SVG 图像不会太小，文本的行高（因此行间距）不会太大，而 SVG 图像的基线仍然与文本的底部对齐。

## 结语

使用 Typst 来显示数学公式挺不错，但对我来说还有点不够。对我来说，由于 Typst 提供的标记语法、数学公式支持以及比 LaTeX 好写好懂的语言，Typst 对我来说更像是一个“better Markdown”，尽管这么说显得对旨在与 LaTeX 竞争的 Typst 有点不公平。目前 Typst 的 release 版本只能导出 SVG 和 PDF，但[基本的 HTML 导出支持](https://github.com/typst/typst/issues/5512)已经合并到了主分支中，所以我十分期待能用 Typst 来写博客的那一天早些到来。