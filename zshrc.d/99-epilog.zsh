# vim: ft=zsh ts=2 sw=2 sts=2 et

_my_omz_end="$(print -P '%D{%s.%.}' 2>/dev/null)"

if [ -t 0 ]; then
  printf '\e[30;1mmy-omz started in %.3fs.\e[m\n' "$((_my_omz_end - _my_omz_start))"
fi

unset _my_omz_start _my_omz_end
