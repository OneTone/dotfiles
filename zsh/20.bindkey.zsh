# vim: ft=zsh ts=2 sw=2 sts=2 et

unix-word-rubout() {
  local WORDCHARS=$'!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'
  zle backward-kill-word
}

zle -N unix-word-rubout
bindkey '^W' unix-word-rubout

if which sudo-command-line >/dev/null 2>&1; then
  bindkey '^[e' sudo-command-line
fi

bindkey '^U' backward-kill-line
bindkey '^[k' kill-whole-line
bindkey '^[l' down-case-word

bindkey '^X^?' where-is
bindkey '^X\^' vi-first-non-blank
bindkey '^X^F' vi-find-next-char
bindkey '^X^T' vi-find-next-char-skip
bindkey '^XF' vi-find-prev-char
bindkey '^XT' vi-find-prev-char-skip
