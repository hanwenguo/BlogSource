import { getCompiler, compile, query } from "./compile";
import * as parse5 from 'parse5';
import type { DefaultTreeAdapterTypes } from "parse5";
import * as fs from "fs";

type Element = DefaultTreeAdapterTypes.Element;
type Node = DefaultTreeAdapterTypes.Node;
type ParentNode = DefaultTreeAdapterTypes.ParentNode;

export async function getCompiledHtml(src: {
    path?: string,
    source?: string
}, options: Record<string, any> = {}): Promise<string> {
    const compiler = getCompiler();
    const html = await compile(src, options)(compiler);
    return html || '';
}

function getBodyContentFromHtml(html: string): string {
    // Parse the HTML document
    const document = parse5.parse(html);
    let bodyContentHtml = '';
    
    // Helper function to find elements by name
    function findElementsByName(node: Node, name: string): Element[] {
        const results: Element[] = [];
        
        if (isElement(node) && node.nodeName.toLowerCase() === name) {
            results.push(node);
        }
        
        if (isParentNode(node) && node.childNodes) {
            for (const child of node.childNodes) {
                results.push(...findElementsByName(child, name));
            }
        }
        
        return results;
    }
    
    // Helper function to check if a node is an Element
    function isElement(node: Node): node is Element {
        return node.nodeName !== '#text' && node.nodeName !== '#document' && 'tagName' in node;
    }
    
    // Helper function to check if a node is a ParentNode
    function isParentNode(node: Node): node is ParentNode {
        return 'childNodes' in node;
    }
    
    // Find the body element and serialize its content
    const bodyElements = findElementsByName(document, 'body');
    if (bodyElements.length > 0) {
        const body = bodyElements[0];
        bodyContentHtml = parse5.serialize({
            nodeName: '#document-fragment',
            childNodes: body.childNodes || []
        });
    }
    
    return bodyContentHtml;
}

function getFrontmatter(mainFilePath: string): Record<string, any> {
    try {
        const data = query(mainFilePath, "<frontmatter>", true)(getCompiler());
        if (data) {
            return data;
        } else {
            console.log(` \x1b[1;31mError\x1b[0m ${mainFilePath} has no frontmatter`);
            throw new Error(`Failed to get frontmatter from ${mainFilePath}`);
        }
    } catch (e) {
        console.log(` \x1b[1;31mError\x1b[0m ${mainFilePath} has no frontmatter`);
        throw e;
    }
}

export async function renderTypstSource(
    source: string, 
    options: Record<string, any> = {}
): Promise<string> {
    const { template } = options;
    const compiledHtml = await getCompiledHtml({ source }, options);
    if (!compiledHtml) {
        throw new Error(`Failed to compile Typst document with the following source: \n${source}`);
    } else {
        return getBodyContentFromHtml(compiledHtml);
    }
}

export async function renderTypstFile(
    mainFilePath: string, 
    options: Record<string, any> = {}
): Promise<{ frontmatter: Record<string, any>, html: string }> {
    let frontmatter = {};
    try {
        frontmatter = getFrontmatter(mainFilePath);
    } catch (e) {
        console.log(` \x1b[1;31mError\x1b[0m Failed to get frontmatter from ${mainFilePath}`);
    }
    const compiledHtml = await getCompiledHtml({ path: mainFilePath }, options);
    if (!compiledHtml) {
        throw new Error(`Failed to compile Typst document: ${mainFilePath}`);
    }
    const bodyContentHtml = getBodyContentFromHtml(compiledHtml);
    return {
        frontmatter,
        html: bodyContentHtml
    };
}