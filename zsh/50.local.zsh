# vim: ft=zsh ts=2 sw=2 sts=2 et

: "${_ZSHRC_LOCAL:=$HOME/.zshrc.local}"
if [ -f "$_ZSHRC_LOCAL" ]; then
  source "$_ZSHRC_LOCAL"
fi
