# vim: ft=zsh ts=2 sw=2 sts=2 et

_add_omz_plugin() {
  local arg cmd plug
  for arg; do
    cmd="${arg%%:*}"
    plug="${arg##*:}"
    if [ "$cmd" ]; then
      : "${plug:=$cmd}"
      which "$cmd" >/dev/null 2>&1 && omz plugin load "$plug"
    else
      [ "$plug" ] && omz plugin load "$plug"
    fi
  done
}

: "${_ZSHRC_PLUG:=$HOME/.zshrc.plug}"
if [ -f "$_ZSHRC_PLUG" ]; then
  [ ${(%):-%(!.0.1)} = 0 ] || _add_omz_plugin 'sudo'
  . "$_ZSHRC_PLUG"
fi

unset -f _add_omz_plugin
