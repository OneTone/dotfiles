# vim: ft=zsh ts=2 sw=2 sts=2 et

() {
  local EDITORS=('vim' 'emacs' 'vi' 'nano')
  local ED
  for ED in "$EDITORS[@]"; do
    if which "$ED" >/dev/null 2>&1; then
      export EDITOR="$ED"
      break
    fi
  done
}
