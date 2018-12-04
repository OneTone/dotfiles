# vim: ft=zsh ts=2 sw=2 sts=2 et

ZSH_CUSTOM="$HOME/.dotfiles/zsh"

ZSH_THEME='onetone'

_add_cmd_plugin() {
  local _cmd
  for _cmd; do
    which "$_cmd" >/dev/null 2>&1 && plugins+=("$_cmd")
  done
}

case "$OSTYPE" in
  darwin*)
    plugins=('osx')
    _add_cmd_plugin 'brew'
    ;;
  *) plugins=() ;;
esac

[ "$(id -u)" = 0 ] || plugins+=('sudo')

plugins+=(
  'colored-man-pages'
  'command-not-found'
  'encode64'
  'extract'
  'history'
  'jsontools'
  'urltools'
  'web-search'
  'zsh_reload'
  'zsh-navigation-tools'
)

_add_cmd_plugin 'adb' 'docker' 'git' 'nmap' 'pip' 'repo' 'vagrant'
unset -f _add_cmd_plugin

. "$ZSH/oh-my-zsh.sh"