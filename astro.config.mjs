// @ts-check
import { defineConfig } from 'astro/config';

import mdx from '@astrojs/mdx';

// https://astro.build/config
export default defineConfig({
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
    }
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