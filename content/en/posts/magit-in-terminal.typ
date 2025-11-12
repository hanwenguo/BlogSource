#import "/typ/templates/template.typ": *
#show: base-template.with(
  title: "Magit in Terminal",
  date: "2025-11-11T17:07:00-07:00",
  tags: ("emacs", "magit", "terminal"),
)

The following is a script I use to open Magit in current directory from terminal:

```bash
#!/usr/bin/env bash
git_root=$(git rev-parse --show-toplevel)
emacsclient -c -n -a emacs -e "(progn (magit-status \"${git_root}\") (delete-other-windows))"
if [[ -f `which osascript` ]]; then
  osascript -e "tell application \"Emacs\" to activate"
fi
```

I put this script in my `PATH` as `magit`, so I can just run `magit` in any git repository from terminal to open Magit in Emacs. The original source for this script comes from #link("https://christiantietze.de/posts/2021/07/magit-from-terminal/")[Christian Tietze's post], and I have modified it to make it create a new frame with only one window showing Magit status. I also created another script with `-nw` in place of `-c -n` and removed the part that activates Emacs to open Magit in TTY Emacs directly.