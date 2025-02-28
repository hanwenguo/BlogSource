import { type Plugin, type ViteDevServer } from "vite";
import fs from "node:fs/promises";
import { pathToFileURL } from "node:url";
import { renderTypstFile } from "./renderer.js";

export type TypstComponent = {
    name: "TypstComponent";
    frontmatter: Record<string, any>;
    file: string;
    url?: string;
    html: string;
}

export default function (config: Record<string, any> = {}): Plugin {
    let server: ViteDevServer;
    const plugin: Plugin = {
        name: 'vite-plugin-typst',
        configureServer(_server) {
            // _server.watcher.on('change', (event) => console.log({ event }));
            server = _server;
        },
        handleHotUpdate({ modules }) {
            for (const mod of modules) {
                server.moduleGraph.invalidateModule(mod);
            }
            // console.log(server.moduleGraph.fileToModulesMap)
        },
        async transform(_code: string, id: string) {
            if (id.endsWith('.typ')) {
                const { frontmatter, html } = await renderTypstFile(
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
        // async load(id, options) {
        // }
    }

    return plugin;
}