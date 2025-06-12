import type { AstroRenderer, AstroIntegration, ContentEntryType, HookParameters } from "astro";
import vitePluginTypst from "./vite";
import { fileURLToPath } from "node:url";
// import { renderTypstFile } from "./renderer";
import { renderTypstFileToHtml } from "./compiler";
import nodeResolve from "@rollup/plugin-node-resolve";
import type { PluginOption } from "vite";
import { createResolver, defineIntegration, watchDirectory } from "astro-integration-kit";

const PACKAGE_NAME = 'astro-typst';
/**
 * Change this to `true` if you want to run the code.
 * Change it to `false` before publishing.
 */
import { isDebug } from "./debug.js";
import type { AstroTypstConfig } from "./prelude";

function getRenderer(): AstroRenderer {
    const serverEntrypoint = (isDebug ? "" : "astro-typst/") + "dist/renderer/index.js";
    return {
        name: PACKAGE_NAME,
        serverEntrypoint,
    };
}

type SetupHookParams = HookParameters<'astro:config:setup'> & {
	// `addPageExtension` and `contentEntryType` are not a public APIs
	// Add type defs here
	addPageExtension: (extension: string) => void;
	addContentEntryType: (contentEntryType: ContentEntryType) => void;
};

const { resolve: resolver } = createResolver(import.meta.url);

export default function typstIntegration(
    config: AstroTypstConfig
): AstroIntegration {
    return {
        name: "typst",
        hooks: {
            'astro:config:setup': (options) => {
                const { addRenderer, addContentEntryType, addPageExtension, updateConfig } = (options as SetupHookParams);
                watchDirectory(options, resolver());
                addRenderer(getRenderer());
                addPageExtension('.typ');
                addContentEntryType({
                    extensions: ['.typ'],
                    handlePropagation: false,
                    async getEntryInfo({ fileUrl, contents }) {
                        const mainFilePath = fileURLToPath(fileUrl);
                        let { frontmatter } = await renderTypstFileToHtml(
                            mainFilePath,
                            config?.options
                        );
                        return {
                            data: frontmatter,
                            rawData: contents,
                            body: contents,
                            slug: frontmatter?.slug as any,
                        };
                    },
                    contentModuleTypes: `
                    declare module 'astro:content' {
  interface Render {
    '.typ': Promise<{
      Content: import('astro').MarkdownInstance<{}>['Content'];
    }>;
  }
}`
                });
                updateConfig({
                    vite: {
                        build: {
                            rollupOptions: {
                                external: [
                                    "@myriaddreamin/typst-ts-node-compiler",
                                ],
                            }
                        },
                        plugins: [nodeResolve(), vitePluginTypst(config) as PluginOption],
                    },
                });
            },
            "astro:config:done": (params) => {
                params.injectTypes(
                    {
                        filename: "astro-i18n.d.ts",
                        content: `declare module '*.typ' {
    const component: () => any;
    export default component;
}`,
                    }
                )
            }
        }
    }
}