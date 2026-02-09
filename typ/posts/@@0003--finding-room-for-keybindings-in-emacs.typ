#import "/_template/template.typ": template, ln, tr, inline-tree
#show: template(
  title:      [Finding Room for Keybindings in Emacs],
  date:       datetime(year: 2025, month: 11, day: 27, hour: 18, minute: 58, second: 00),
  tags:       ("emacs",),
  identifier: "0003",
  taxon: "Post",
)

There are so many commands that I want to bind to keys in Emacs, but the keyboard is crowded already. In the #link("https://www.gnu.org/software/emacs/manual/html_node/elisp/Key-Binding-Conventions.html")[Key Binding Conventions section in the GNU Emacs Lisp Reference Manual], it says that `C-c` followed by a letter as well as `F5` through `F9` are reserved for users. However, I, just like any sane Emacs user would do, tries to put groups of related commands under prefixes, which means that such a commmand needs at least three keystrokes to invoke (the `C-c`, the letter prefix, and the keybinding in the prefix). This is anti-productive.

Luckily, there are some keybindings in Emacs that are not that useful for me (and maybe others as well), so I can repurpose them for my own use. The following are some of such keybindings. Note that many of these are useless for me because they are more relevant to terminal Emacs, while I almost always use Emacs in a graphical environment, so YMMV. 

- `C-z`: By default, this is bound to `suspend-frame`, which could be replaced by the window manager's own shortcut for minimizing windows on most systems. It may still be useful on terminal Emacs though.
- `C-t`: This is bound to `transpose-chars`, which turns `a|bc` into `ba|c` (where `|` is the cursor). Does anyone really use this? I never do. (But I do find other transpose commands useful.)
- #raw(block: false, "M-`"): This is bound to `tmm-menubar`, which shows a text-based menu bar, which is not very useful in graphical Emacs.
- `C-i` and `C-m`: Due to historical reasons, these are, by default, recognized as `TAB` and `RET` respectively. This is still relevant in terminal Emacs, since some terminals may not be able to distinguish them. But in graphical Emacs, it is possible to distinguish these control characters from `TAB` and `RET`, see #link("https://emacs.stackexchange.com/questions/220/how-to-bind-c-i-as-different-from-tab/221#221")[these] #link("https://emacs.stackexchange.com/questions/17509/how-to-distinguish-c-i-from-tab")[relevant] #link("https://emacs.stackexchange.com/questions/220/how-to-bind-c-i-as-different-from-tab")[discussions] on Emacs Stack Exchange.

That gives me at least five more prefixes to use for my own keybindings, which saves me a lot of keystrokes, and I hope it helps you as well. Happy hacking!
