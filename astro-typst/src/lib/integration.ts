import type { AstroRenderer, AstroIntegration, ContentEntryType, HookParameters } from "astro";
import vitePluginTypst from "./vite";
import { fileURLToPath } from "node:url";
import { renderTypstFile } from "./renderer";
import nodeResolve from "@rollup/plugin-node-resolve";

const PACKAGE_NAME = 'astro-typst';
const isDebug = false;

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

export default function typstIntegration(
    config = {
        options: {
            template: "",
        }
    },
): AstroIntegration {
    return {
        name: "typst",
        hooks: {
            'astro:config:setup': (options) => {
                const { addRenderer, addContentEntryType, addPageExtension, updateConfig } = (options as SetupHookParams);
                addRenderer(getRenderer());
                addPageExtension('.typ');
                addContentEntryType({
                    extensions: ['.typ'],
                    handlePropagation: false,
                    async getEntryInfo({ fileUrl, contents }) {
                        const mainFilePath = fileURLToPath(fileUrl);
                        let { frontmatter } = await renderTypstFile(
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
                        plugins: [nodeResolve(), vitePluginTypst(config)],
                    },
                });
            }
        }
    }
}