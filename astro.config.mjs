// @ts-check
import { defineConfig } from 'astro/config';

import remarkMath from 'remark-math';
import rehypeTypst from '@myriaddreamin/rehype-typst';

import mdx from '@astrojs/mdx';

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

  markdown: {
    shikiConfig: {
      themes: {
        dark: 'github-dark',
        light: 'github-light'
      },
      wrap: false
    },
    remarkPlugins: [remarkMath],
    rehypePlugins: [rehypeTypst]
  },

  vite: {
      build: {
          assetsInlineLimit: 0,
      }
  },

  experimental: {
    contentIntellisense: true,
  },

  integrations: [mdx()]
});