import type { NamedSSRLoadedRendererValue } from "astro";
import type { TypstComponent } from "../lib/prelude";
import { AstroError } from "astro/errors";

export async function check(
    Component: any,
    props: any,
    { default: children = null, ...slotted } = {},
) {
    if (typeof Component !== 'function') return false;
	console.log('check', { Component: Component.prototype, props, children, slotted });
	return !children;
}

export async function renderToStaticMarkup(t: TypstComponent, props: {}) {
	return { html: t.html };
}

const renderer: NamedSSRLoadedRendererValue = {
    name: "astro-typst",
	check,
    renderToStaticMarkup,
	supportsAstroStaticSlot: true,
}

function throwEnhancedErrorIfOrgComponent(error: Error, Component: any) {
    if (Component[Symbol.for('org-component')]) {
        // if it's an existing AstroError, we don't need to re-throw, keep the original hint
        if (AstroError.is(error)) return;
        // Provide better title and hint for the error overlay
        (error as any).title = error.name;
        (error as any).hint =
            `This issue often occurs when your Typst component encounters runtime errors.`;
        throw error;
    }
}

export default renderer;