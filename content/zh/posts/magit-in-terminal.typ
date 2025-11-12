#import "/typ/templates/template.typ": *
#show: base-template.with(
  title: "从终端启动 Magit",
  date: "2025-11-11T17:07:00-07:00",
  tags: ("emacs", "magit", "terminal"),
)

// The following is a script I use to open Magit in current directory from terminal:
我用下面这段脚本从终端在当前目录打开 Magit：

```bash
#!/usr/bin/env bash
git_root=$(git rev-parse --show-toplevel)
emacsclient -c -n -a emacs -e "(progn (magit-status \"${git_root}\") (delete-other-windows))"
if [[ -f `which osascript` ]]; then
  osascript -e "tell application \"Emacs\" to activate"
fi
```

// I put this script in my PATH as `magit`, so I can just run `magit` in any git repository from terminal to open Magit in Emacs. The original source for this script comes from #link("https://christiantietze.de/posts/2021/07/magit-from-terminal/")[Christian Tietze's post], and I have modified it to make it create a new frame with only one window showing Magit status. I also created another script with `-nw` in place of `-c -n` to open Magit in TTY Emacs directly.

我把这段脚本放在 `PATH` 里，命名为 `magit`，这样就可以在终端中直接打开 Magit。这段脚本大部分来自#link("https://christiantietze.de/posts/2021/07/magit-from-terminal/")[Christian Tietze 的文章]，但我对其进行了修改，使其创建一个新 frame，并且只显示 Magit 状态的一个 window。一个变种是，如果将 `-c -n` 替换为 `-nw` 并去除唤起窗口的部分，就可以直接在 TTY Emacs 中打开 Magit。