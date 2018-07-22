# vim: ft=zsh ts=2 sw=2 sts=2 et

if which vim >/dev/null 2>&1; then
  export EDITOR=vim
elif which emacs >/dev/null 2>&1; then
  export EDITOR=emacs
elif which vi >/dev/null 2>&1; then
  export EDITOR=vi
elif which nano >/dev/null 2>&1; then
  export EDITOR=nano
fi
