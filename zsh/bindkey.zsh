# vim: ft=zsh ts=2 sw=2 sts=2 et

WORDCHARS=$'!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'

autoload -U select-word-style
select-word-style bash

type sudo-command-line >/dev/null 2>&1 && \
bindkey '^[e' sudo-command-line
bindkey '^U' backward-kill-line
bindkey '^W' backward-delete-word
