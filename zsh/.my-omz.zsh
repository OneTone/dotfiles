# vim: ft=zsh ts=2 sw=2 sts=2 et

_my_omz_start="$(print -P '%D{%s.%.}' 2>/dev/null)"

ZSH_CUSTOM="${${(%):-%x}:A:h}"

plugins=()
[ ${(%):-%(!.0.1)} = 0 ] || plugins+=('sudo')

: "${_ZSHRC_PLUG:=$HOME/.zshrc.plug}"
if [ -f "$_ZSHRC_PLUG" ]; then
  _add_omz_plugin() {
    local arg cmd plug
    for arg; do
      cmd="${arg%%:*}"
      plug="${arg##*:}"
      if [ "$cmd" ]; then
        : "${plug:=$cmd}"
        which "$cmd" >/dev/null 2>&1 && plugins+=("$plug")
      else
        [ "$plug" ] && plugins+=("$plug")
      fi
    done
  }

  source "$_ZSHRC_PLUG"
  unset -f _add_omz_plugin
fi

autoload -U add-zsh-hook
add-zsh-hook -D preexec '*omz*'
add-zsh-hook -D precmd '*omz*'

source "$ZSH/oh-my-zsh.sh"

_my_omz_end="$(print -P '%D{%s.%.}' 2>/dev/null)"
printf '\e[30;1mmy-omz started in %.3fs.\e[m\n' "$((_my_omz_end - _my_omz_start))"
unset _my_omz_start _my_omz_end
