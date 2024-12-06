import { defineCollection, z } from 'astro:content';

import { glob, file } from 'astro/loaders';

const blog = defineCollection({
    loader: glob({ pattern: "**/posts/*.{md,mdx}", base: "content" }),
    schema: z.object({
        title: z.string(),
        date: z.coerce.date(),
        tags: z.array(z.string()),
        draft: z.boolean().optional(),
        enableMath: z.boolean().optional(),
        enableToc: z.boolean().optional(),
    })
});

const poems = defineCollection({
    loader: glob({ pattern: "zh/poems/*.md", base: "content" }),
    schema: z.object({
        title: z.string(),
        date: z.coerce.date(),
    })
});

const home = defineCollection({
    loader: glob({ pattern: "*/index.mdx", base: "content" }),
    schema: z.object({
        enableMath: z.boolean().optional(),
    })
});

export const collections = { blog, poems, home };