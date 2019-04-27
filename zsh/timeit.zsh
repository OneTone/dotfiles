# vim: ft=zsh ts=2 sw=2 sts=2 et

_timeit_now() {
  print -P '%D{%s.%.}' 2>/dev/null
}

_preexec_timeit() {
  _TIMEIT_START="$(_timeit_now)"
}

_precmd_timeit() {
  if [ "$_TIMEIT_START" ]; then
    local DURATION="$(printf '%.3fs' $(($(_timeit_now) - _TIMEIT_START)))"
    printf '\e[%dC\e[1;31m%s\e[m\n' $((COLUMNS - ${#DURATION} - 1)) "$DURATION"
    unset _TIMEIT_START
  fi
}

preexec_functions+=(_preexec_timeit)
precmd_functions+=(_precmd_timeit)
