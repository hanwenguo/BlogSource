#import "/_template/template.typ": template, ln, tr, inline-tree
#show: template(
  title:      [How to Find a Color Scheme Quickly],
  date:       datetime(year: 2025, month: 04, day: 19, hour: 12, minute: 52, second: 00),
  tags:       ("blog", "design",),
  identifier: "0002",
  taxon: "Post",
)

There are always things in the world that require some level of visual design. Taking some things I've had to do recently as examples: creating slideshows, drawing charts for papers, making posters, and designing my homepage – having some design is always better than having none. In the design process, choosing fonts is relatively simple. After doing this a few times, you slowly build up a set of fonts that can be combined for various occasions. While layout has many details, as long as you follow some basic principles like alignment, white space, contrast, and unity, the result won't be poor. However, choosing a color scheme is often the hardest part for me.

#inline-tree(
  title: [Criteria for Choosing a Color Scheme],
)[
A “color scheme” isn't just a set of colors found randomly via a search engine or produced by a generator. Most such schemes are just a collection of color blocks and RGB values. They might look okay at first glance, but for a non-professional like me, it's hard to directly apply them to actual designs. This is just a mere collection of colors, not a truly usable color scheme. For me, a color scheme should meet these criteria:

- Clearly defines the purpose of each color, such as background color, text color, accent color, etc.
- Based on the defined color purposes, meets certain accessibility standards, including:
    - Sufficient contrast between text and background.
    - Colorblind-friendly.
]

#inline-tree(
  title: [Where to Find Color Schemes],
)[
After several fruitless attempts, I decided not to waste time on search engines anymore. My inspiration came one day when I was staring at my Emacs. At that moment, I suddenly realized that code editor color schemes are arguably a perfect solution because they:

- Have very clear color purposes.
- Usually don't have too many primary colors.
- Every code editor has a huge number of color schemes to choose from.
- These schemes are usually carefully designed rather than randomly generated.
- Many schemes meet certain accessibility requirements.
- You can experience the effect of these schemes right in the code editor.
- Provide a sense of visual unity with one's daily workflow.

The only concern is the copyright issue. Although colors themselves are not protected by copyright (at least as far as I know), to avoid unnecessary trouble, one should try to use schemes that are explicitly licensed for use.
]

#inline-tree(
  title: [How to Evaluate],
)[
#link("https://palette-tester.9elements.com")[Palette Tester] is a tool for testing the contrast of a color scheme. It can test contrast under WCAG 2.1 (AA) or APCA Contrast standards. #link("https://davidmathlogic.com/colorblind/#%23D81B60-%231E88E5-%23FFC107-%23004D40")[Coloring for Colorblindness] and #link("https://www.whocanuse.com")[Who Can Use] are two tools for testing the colorblind-friendliness of colors. They can show how the same set of colors appears to people with different types of color blindness.
]

#inline-tree(
 title: [My Choice],
)[
I have always used the #link("https://protesilaos.com/emacs/modus-themes")[Modus Themes] color scheme in Emacs. Coincidentally, this color scheme was designed with accessibility in mind, achieving the WCAG AAA standard, and provides variants friendly to two types of color blindness (deuteranopia and tritanopia). The color scheme of the webpage you are currently viewing comes from the tinted variant of Modus Themes.
]
