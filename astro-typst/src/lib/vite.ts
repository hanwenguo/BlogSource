import { type HmrContext, type Plugin, type ResolvedConfig, type ViteDevServer } from "vite";
import fs from "node:fs/promises";
import { pathToFileURL } from "node:url";
// import { renderTypstFile } from "./renderer.js";
import type { AstroTypstConfig } from "./prelude.js";
import { renderTypstFileToHtml } from "./compiler.js";

function isTypstFile(id: string) {
    return /\.typ$/.test(id);
}

function debug(...args: any[]) {
    if (process.env.DEBUG) {
        debug(...args);
    }
}

export default function (config: AstroTypstConfig = {}): Plugin {
    let server: ViteDevServer;
    const plugin: Plugin = {
        name: 'vite-plugin-typst',
        enforce: 'pre',

        load(id) {
            if (!isTypstFile(id)) return;
            debug(`[vite-plugin-astro-typ] Loading id: ${id}`);
            // const { path, opts } = extractOpts(id);
        },

        configureServer(_server) {
            server = _server;
            // listen for .typ file changes
            server.watcher.on('change', async (filePath) => {
                if (isTypstFile(filePath)) {
                    const modules = server.moduleGraph.getModulesByFile(filePath);
                    if (modules) {
                        for (const mod of modules) {
                            debug(`[vite-plugin-astro-typ] Invalidating module: ${mod.id}`);
                            server.moduleGraph.invalidateModule(mod);
                        }
                    } else {
                        debug(`[vite-plugin-astro-typ] No modules found for file: ${filePath}`);
                        server.ws.send({
                            type: 'full-reload',
                            path: '*', // reload all files
                        });
                    }
                }
            });
        },
        async transform(code: string, id: string) {
            if (!isTypstFile(id)) return;
            // const { path, opts } = extractOpts(id);
            await new Promise((resolve) => setTimeout(resolve, 1000));

            const { frontmatter, html } = await renderTypstFileToHtml(
                id,
                // TODO: getHeadings
                config.options
            );
            // const fileId = id.split('?')[0];
            // const runtime = "astro/runtime/server/index.js";
            return {
                code: `
import { createComponent, render, renderComponent, unescapeHTML } from "astro/runtime/server/index.js";
export const name = "TypstComponent";
export const file = ${JSON.stringify(id)};
export const url = ${JSON.stringify(pathToFileURL(id))};
export const frontmatter = ${JSON.stringify(frontmatter)};
export const html = ${JSON.stringify(html)};

export function rawContent() {
    return ${JSON.stringify(await fs.readFile(id, 'utf-8'))};
}
export function compiledContent() {
    return html;
}
export function getHeadings() {
    return undefined;
}

export const Content = createComponent((result, _props, slots) => {
    frontmatter.file = file;
    frontmatter.url = url;
    return render\`\${unescapeHTML(html)}\`;
});
export default Content;
`,
                map: null,
            }
        }
    }

    return plugin;
}