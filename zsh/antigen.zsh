# vim: ft=zsh ts=2 sw=2 sts=2 et

for _ANTIGEN_HOME in "$HOME/.antigen" '/usr/local/share' '/usr/share'; do
  _ANTIGEN_ZSH="$_ANTIGEN_HOME/antigen/antigen.zsh"
  if [ -e "$_ANTIGEN_ZSH" ]; then
    . "$_ANTIGEN_ZSH"

    antigen bundle zsh-users/zsh-autosuggestions
    antigen bundle zsh-users/zsh-completions
    antigen bundle zsh-users/zsh-syntax-highlighting

    antigen apply
    break
  fi
done

unset _ANTIGEN_ZSH
unset _ANTIGEN_HOME
