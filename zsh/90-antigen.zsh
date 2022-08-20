# vim: ft=zsh ts=2 sw=2 sts=2 et

find_antigen() {
  local ANTIGEN_DIRS=(
    "$HOME/.antigen/"
    '/usr/local/share/'
    '/usr/share/zsh-'
  )
  local D
  for D in "$ANTIGEN_DIRS[@]"; do
    local ANTIGEN_ZSH="${D}antigen/antigen.zsh"
    if [ -f "$ANTIGEN_ZSH" ]; then
      printf '%s' "$ANTIGEN_ZSH"
      break
    fi
  done
}

: "${ANTIGEN_ZSH:=$(find_antigen)}"
if [ -f "$ANTIGEN_ZSH" ]; then
  . "$ANTIGEN_ZSH"

  local M
  for M in "$ANTIGEN_MODULES[@]"; do
    antigen bundle "$M"
  done
  antigen apply
fi

unset -f find_antigen
