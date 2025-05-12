import { NodeCompiler, NodeTypstProject, type CompileArgs } from "@myriaddreamin/typst-ts-node-compiler";
import fs from "node:fs/promises";
import * as parse5 from 'parse5';
import type { DefaultTreeAdapterTypes } from "parse5";
/**
* The flag for indicating whether there is any error during the build process.
*/
export let hasError = false;

/**
* The arguments for the compiler.
*/
const compileArgs: CompileArgs = {
    workspace: ".",
    inputs: {
        "x-target": "web",
        // ...(astroConfig.site ? { "x-url-base": astroConfig.site } : {}),
    },
    fontArgs: [{ fontPaths: ["./build/fonts"] }],
};

/**
* The arguments for querying metadata.
*
* @type {import("@myriaddreamin/typst-ts-node-compiler").CompileArgs}
*/
const queryArgs = {
    ...compileArgs,
    inputs: {
        "x-meta": "true",
        ...compileArgs.inputs,
    },
};  

/**
* Lazily created compiler.
*/
let _compiler: NodeCompiler | undefined = undefined;
/**
* Lazily created compiler.
*/
export const getCompiler = () => (_compiler ||= NodeCompiler.create(compileArgs));

/**
* Compiles the source file to HTML.
*
* @example
* compile("src/index.typ")(compiler());
*/
export const compile = (src: {
    path?: string,
    source?: string
}, options: Record<string, any>) => {
    return async (compiler: NodeTypstProject) => {
        if (!src.path && !src.source) {
            throw new Error("Either path or source must be provided");
        }
        if (src.path && src.source) {
            throw new Error("Both path and source cannot be provided");
        }
        let mainFileContent = "";
        if (src.path) {
            // compileOptions = { mainFilePath: src.path, ...compileOptions };
            mainFileContent = await fs.readFile(src.path, "utf-8");
        } else {
            // compileOptions = { mainFileContent: src.source, ...compileOptions };
            mainFileContent = src.source || "";
        }
        let compileOptions = {
            mainFileContent: `${options.template}\n${mainFileContent}`,
            inputs: {
                ...compileArgs.inputs,
                "x-target": `web`,
            }
        };
        const htmlResult = compiler.mayHtml(compileOptions);
        
        const isError = htmlResult.hasError();
        hasError = hasError || isError;
        
        // Print errors if any
        if (isError) {
            htmlResult.printErrors();
        }
        
        const htmlContent = htmlResult.result;
        
        // Log results and evict cache before returning
        if (isError) {
            console.log(` \x1b[1;31mError Compiling\x1b[0m ${src}`);
            throw new Error(`Error compiling Typst document ${src}`);
        } else {
            // console.log(` \x1b[1;32mCompiled\x1b[0m ${src}`);
            // Evicts the cache unused in last 30 runs
            getCompiler()?.evictCache(30);
        }
        
        // Return HTML content if available
        if (htmlContent && htmlContent.length > 0) {
            return htmlContent;
        }
    };
};

/**
* Triggers query on the source file
*
* All the errors are caught and printed to the console.
*
* @param src The source file path.
* @param selector The selector for the query.
* @param one Casts the result to a single element if the result is an array and the length is 1.
*
* @returns {any[] | any | undefined}
*
* @example
* query("src/index.typ", "<rss-feed>", true)(compiler());
*/
export const query = (src: string, selector: string, one: boolean) => {
    return (compiler: NodeTypstProject) => {
        try {
            const queryData = compiler.query(
                { mainFilePath: src, ...queryArgs },
                { selector }
            );
            if (queryData?.length !== undefined) {
                if (one) {
                    if (queryData.length !== 1) {
                        throw new Error(
                            `Query expected one result, but got ${queryData.length}`
                        );
                    }
                    return queryData[0].value;
                }
                return queryData.value;
            }
        } catch (e) {
            hasError = true;
            throw e;
        }
    };
};

/**
* User trigger queries the source file to the destination file or watches the source file
*
* @param src The source file path.
* @param selector The selector for the query.
* @param one Casts the result to a single element if the result is an array and the length is 1.
*
* @returns {import("./types").FileMetaElem | undefined}
*/
export const typstQuery = (src: string, selector: string, one: boolean) => {
    try {
        return query(src, selector, one)(getCompiler());
    } catch (e) {
        console.log(`\x1b[1;31mError\x1b[0m ${src}`);
        console.error(e);
        return;
    }
};


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

export async function renderTypstFileToHtml(
    mainFilePath: string, 
    options: Record<string, any> = {}
): Promise<{ frontmatter: Record<string, any>, html: string }> {
    const mainFileContent = await fs.readFile(mainFilePath, "utf-8");
    const compileOptions = {
        mainFileContent: `${options.template}\n${mainFileContent}`,
        inputs: {
            ...compileArgs.inputs,
            "x-target": `web`,
        }
    };
    const compiler = getCompiler();
    const _result = compiler.compileHtml(compileOptions);
    const result = _result.result;
    if (!result) {
        console.log(` \x1b[1;31mError\x1b[0m ${mainFilePath}`);
        throw new Error(`Failed to compile Typst document: ${mainFilePath}`);
    }

    const htmlResult = compiler.mayHtml(result);
    const isError = htmlResult.hasError();
    hasError = hasError || isError;
    // Print errors if any
    if (isError) {
        htmlResult.printErrors();
    }
    const htmlContent = htmlResult.result;
    // Log results and evict cache before returning
    if (isError) {
        console.log(` \x1b[1;31mError Compiling\x1b[0m ${mainFilePath}`);
        throw new Error(`Error compiling Typst document ${mainFilePath}`);
    }
    if (!htmlContent || htmlContent.length <= 0) {
        console.log(` \x1b[1;31mError\x1b[0m ${mainFilePath}`);
        throw new Error(`Failed to compile Typst document: ${mainFilePath}`);
    }
    const bodyContentHtml = getBodyContentFromHtml(htmlContent);
    const frontmatterResult = compiler.query(
        result,
        { selector: "<frontmatter>" }
    );
    const frontmatter = (frontmatterResult && frontmatterResult.length > 0) ? frontmatterResult[0].value : frontmatterResult.value;
    // Evicts the cache unused in last 30 runs
    getCompiler()?.evictCache(30);
    // Return HTML content if available
    return {
        frontmatter,
        html: bodyContentHtml
    }
}

// const testStr = `#show math.equation: it => {
//   if target() == "html" {
//     html.frame(it)
//   } else {
//     it
//   }
// }

// = Introduction

// asd asdsadasadsaeeeee
// t

// inline formula $a = b$

// displayed formula
// $ sum_(i=1) a_i $

// #figure(
// $ sum_(i=1) a_i $,
// caption: [A caption],
// )
// `;

// const testRes = compile(testStr, "dist/index.html")(getCompiler());
// console.log(testRes);

/*

The code in this file is based on the work of the authors of [typst-doc-cn/news](https://github.com/typst-doc-cn/news). Copyright belongs to the original authors.
The license of the original code is followed:

```
Apache License
Version 2.0, January 2004
http://www.apache.org/licenses/

TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

1. Definitions.

"License" shall mean the terms and conditions for use, reproduction,
and distribution as defined by Sections 1 through 9 of this document.

"Licensor" shall mean the copyright owner or entity authorized by
the copyright owner that is granting the License.

"Legal Entity" shall mean the union of the acting entity and all
other entities that control, are controlled by, or are under common
control with that entity. For the purposes of this definition,
"control" means (i) the power, direct or indirect, to cause the
direction or management of such entity, whether by contract or
otherwise, or (ii) ownership of fifty percent (50%) or more of the
outstanding shares, or (iii) beneficial ownership of such entity.

"You" (or "Your") shall mean an individual or Legal Entity
exercising permissions granted by this License.

"Source" form shall mean the preferred form for making modifications,
including but not limited to software source code, documentation
source, and configuration files.

"Object" form shall mean any form resulting from mechanical
transformation or translation of a Source form, including but
not limited to compiled object code, generated documentation,
and conversions to other media types.

"Work" shall mean the work of authorship, whether in Source or
Object form, made available under the License, as indicated by a
copyright notice that is included in or attached to the work
(an example is provided in the Appendix below).

"Derivative Works" shall mean any work, whether in Source or Object
form, that is based on (or derived from) the Work and for which the
editorial revisions, annotations, elaborations, or other modifications
represent, as a whole, an original work of authorship. For the purposes
of this License, Derivative Works shall not include works that remain
separable from, or merely link (or bind by name) to the interfaces of,
the Work and Derivative Works thereof.

"Contribution" shall mean any work of authorship, including
the original version of the Work and any modifications or additions
to that Work or Derivative Works thereof, that is intentionally
submitted to Licensor for inclusion in the Work by the copyright owner
or by an individual or Legal Entity authorized to submit on behalf of
the copyright owner. For the purposes of this definition, "submitted"
means any form of electronic, verbal, or written communication sent
to the Licensor or its representatives, including but not limited to
communication on electronic mailing lists, source code control systems,
and issue tracking systems that are managed by, or on behalf of, the
Licensor for the purpose of discussing and improving the Work, but
excluding communication that is conspicuously marked or otherwise
designated in writing by the copyright owner as "Not a Contribution."

"Contributor" shall mean Licensor and any individual or Legal Entity
on behalf of whom a Contribution has been received by Licensor and
subsequently incorporated within the Work.

2. Grant of Copyright License. Subject to the terms and conditions of
this License, each Contributor hereby grants to You a perpetual,
worldwide, non-exclusive, no-charge, royalty-free, irrevocable
copyright license to reproduce, prepare Derivative Works of,
publicly display, publicly perform, sublicense, and distribute the
Work and such Derivative Works in Source or Object form.

3. Grant of Patent License. Subject to the terms and conditions of
this License, each Contributor hereby grants to You a perpetual,
worldwide, non-exclusive, no-charge, royalty-free, irrevocable
(except as stated in this section) patent license to make, have made,
use, offer to sell, sell, import, and otherwise transfer the Work,
where such license applies only to those patent claims licensable
by such Contributor that are necessarily infringed by their
Contribution(s) alone or by combination of their Contribution(s)
with the Work to which such Contribution(s) was submitted. If You
institute patent litigation against any entity (including a
cross-claim or counterclaim in a lawsuit) alleging that the Work
or a Contribution incorporated within the Work constitutes direct
or contributory patent infringement, then any patent licenses
granted to You under this License for that Work shall terminate
as of the date such litigation is filed.

4. Redistribution. You may reproduce and distribute copies of the
Work or Derivative Works thereof in any medium, with or without
modifications, and in Source or Object form, provided that You
meet the following conditions:

(a) You must give any other recipients of the Work or
Derivative Works a copy of this License; and

(b) You must cause any modified files to carry prominent notices
stating that You changed the files; and

(c) You must retain, in the Source form of any Derivative Works
that You distribute, all copyright, patent, trademark, and
attribution notices from the Source form of the Work,
excluding those notices that do not pertain to any part of
the Derivative Works; and

(d) If the Work includes a "NOTICE" text file as part of its
distribution, then any Derivative Works that You distribute must
include a readable copy of the attribution notices contained
within such NOTICE file, excluding those notices that do not
pertain to any part of the Derivative Works, in at least one
of the following places: within a NOTICE text file distributed
as part of the Derivative Works; within the Source form or
documentation, if provided along with the Derivative Works; or,
within a display generated by the Derivative Works, if and
wherever such third-party notices normally appear. The contents
of the NOTICE file are for informational purposes only and
do not modify the License. You may add Your own attribution
notices within Derivative Works that You distribute, alongside
or as an addendum to the NOTICE text from the Work, provided
that such additional attribution notices cannot be construed
as modifying the License.

You may add Your own copyright statement to Your modifications and
may provide additional or different license terms and conditions
for use, reproduction, or distribution of Your modifications, or
for any such Derivative Works as a whole, provided Your use,
reproduction, and distribution of the Work otherwise complies with
the conditions stated in this License.

5. Submission of Contributions. Unless You explicitly state otherwise,
any Contribution intentionally submitted for inclusion in the Work
by You to the Licensor shall be under the terms and conditions of
this License, without any additional terms or conditions.
Notwithstanding the above, nothing herein shall supersede or modify
the terms of any separate license agreement you may have executed
with Licensor regarding such Contributions.

6. Trademarks. This License does not grant permission to use the trade
names, trademarks, service marks, or product names of the Licensor,
except as required for reasonable and customary use in describing the
origin of the Work and reproducing the content of the NOTICE file.

7. Disclaimer of Warranty. Unless required by applicable law or
agreed to in writing, Licensor provides the Work (and each
Contributor provides its Contributions) on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied, including, without limitation, any warranties or conditions
of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
PARTICULAR PURPOSE. You are solely responsible for determining the
appropriateness of using or redistributing the Work and assume any
risks associated with Your exercise of permissions under this License.

8. Limitation of Liability. In no event and under no legal theory,
whether in tort (including negligence), contract, or otherwise,
unless required by applicable law (such as deliberate and grossly
negligent acts) or agreed to in writing, shall any Contributor be
liable to You for damages, including any direct, indirect, special,
incidental, or consequential damages of any character arising as a
result of this License or out of the use or inability to use the
Work (including but not limited to damages for loss of goodwill,
work stoppage, computer failure or malfunction, or any and all
other commercial damages or losses), even if such Contributor
has been advised of the possibility of such damages.

9. Accepting Warranty or Additional Liability. While redistributing
the Work or Derivative Works thereof, You may choose to offer,
and charge a fee for, acceptance of support, warranty, indemnity,
or other liability obligations and/or rights consistent with this
License. However, in accepting such obligations, You may act only
on Your own behalf and on Your sole responsibility, not on behalf
of any other Contributor, and only if You agree to indemnify,
defend, and hold each Contributor harmless for any liability
incurred by, or claims asserted against, such Contributor by reason
of your accepting any such warranty or additional liability.

END OF TERMS AND CONDITIONS

APPENDIX: How to apply the Apache License to your work.

To apply the Apache License to your work, attach the following
boilerplate notice, with the fields enclosed by brackets "[]"
replaced with your own identifying information. (Don't include
the brackets!)  The text should be enclosed in the appropriate
comment syntax for the file format. We also recommend that a
file or class name and description of purpose be included on the
same "printed page" as the copyright notice for easier
identification within third-party archives.

Copyright [yyyy] [name of copyright owner]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

The main changes includes eliminating the support for multiple color schemes and 
take input and output as source and result strings instead of file paths.

*/