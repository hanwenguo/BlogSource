#import "/typ/templates/template.typ": *
#show: base-template.with(
  title: "在 Emacs 中腾出更多快捷键空间",
  date: "2025-11-27T18:58:00-07:00",
  tags: ("emacs",),
)

Emcas 默认的快捷键绑定几乎占满了整个键盘，没有留下许多给用户自定义的空间。虽然 #link("https://www.gnu.org/software/emacs/manual/html_node/elisp/Key-Binding-Conventions.html")[GNU Emacs Lisp 参考手册里的快捷键约定章节] 提到 `C-c` 后接字母的快捷键以及 `F5` 到 `F9` 是预留给用户的，但出于方便记忆的目的，我也想把相关的命令归类在同一个前缀下。这就意味着执行一个命令至少得按三次键（先按 `C-c`，再按前缀字母，最后才是具体功能的按键）。这导致按键的效率很低。

好在 Emacs 里有一些默认快捷键对我（可能对别人也是）没多大用处，正好可以拿来重新利用。下面列出了几个这样的键位。不过，其中很多对我没用，是因为我主要使用GUI Emacs；对于终端 Emacs 来说，情况可能会有所不同，见仁见智。

- `C-z`: 默认绑定的是 `suspend-frame`。在大多数系统上，这完全可以用窗口管理器自带的“最小化窗口”快捷键代替。不过在终端 Emacs 里它可能还是有点用的。
- `C-t`: 绑定的是 `transpose-chars`，作用是把 `a|bc` 变成 `ba|c`（`|` 代表光标位置）。真的有人用这个功能吗？反正我从来不用。（但是其他的 transpose 命令还挺好用的。）
- #raw(block: false, "M-`"): 绑定的是 `tmm-menubar`，会显示一个基于文本的菜单栏。这在图形界面 Emacs 里基本用不到。
- `C-i` 和 `C-m`: 由于历史原因，它们默认分别被识别为 `TAB` 和 `RET`。在终端 Emacs 里这种识别是有用的，因为有些终端分不清它们。但在图形界面 Emacs 中，可以将这两个控制字符与 `TAB` 和 `RET` 区分开来，可以参考 Emacs Stack Exchange 上关于 #link("https://emacs.stackexchange.com/questions/220/how-to-bind-c-i-as-different-from-tab/221#221")[区分] #link("https://emacs.stackexchange.com/questions/17509/how-to-distinguish-c-i-from-tab")[键位的] #link("https://emacs.stackexchange.com/questions/220/how-to-bind-c-i-as-different-from-tab")[讨论]。

这样就多了五个前缀键位可以用来绑定自己的命令。希望这些技巧对读者也有帮助。Happy hacking!