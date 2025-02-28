import type { NamedSSRLoadedRendererValue } from "astro";
import type { TypstComponent } from "../lib/vite";

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

export default renderer;