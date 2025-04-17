import type { CompileDocArgs } from "@myriaddreamin/typst-ts-node-compiler";

/**
 * Either a string or an object for multiple files.
*/
export type TypstDocInput = CompileDocArgs | string;

export type TypstComponent = {
    name: "TypstComponent";
    frontmatter: Record<string, any>;
    file: string;
    html: string;
}

export type AstroTypstRenderOption = {
    /** The rem size to use for the typst renderer */
    remPx?: number;
    [key: string]: any;
}

export type AstroTypstConfig = {
    /** The options for the typst renderer */
    options?: AstroTypstRenderOption;
}