// @ts-check
import { defineConfig } from 'astro/config';

import remarkMath from 'remark-math';
import rehypeTypst from '@myriaddreamin/rehype-typst';
import rehypeFigure from "@microflash/rehype-figure";

import mdx from '@astrojs/mdx';

import { typst } from 'astro-typst';

// https://astro.build/config
export default defineConfig({
  site: "https://hanwen.io",

  prefetch: true,

  i18n: {
      locales: ['en', 'zh'],
      defaultLocale: 'en',
    //   routing: "manual"
    routing: {
        prefixDefaultLocale: true,
        redirectToDefaultLocale: false,
    }
  },

  integrations: [
    mdx(),
    typst({
      options: {
        remPx: 16,
      //   template: '#import "/typ/templates/template.typ": *\n#show: base-template\n',
      },
      fontArgs: [
        { fontPaths: ['./typ/fonts']}
      ],
      target: "html"
    })
  ],

  markdown: {
    shikiConfig: {
      themes: {
        dark: 'github-dark',
        light: 'github-light'
      },
      wrap: false
    },
    remarkPlugins: [remarkMath],
    rehypePlugins: [rehypeTypst, rehypeFigure]
  },

  vite: {
      build: {
          assetsInlineLimit: 0,
          rollupOptions: {
            external: ["astro-typst"]
          },
      }
  },

  experimental: {
    contentIntellisense: true,
  },
});