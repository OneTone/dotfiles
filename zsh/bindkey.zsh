WORDCHARS=$'!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'

autoload -U select-word-style
select-word-style bash

bindkey '^[e' sudo-command-line
bindkey '^U' backward-kill-line
bindkey '^W' backward-delete-word
