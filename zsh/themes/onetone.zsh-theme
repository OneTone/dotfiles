# vim: ft=zsh ts=2 sw=2 sts=2 et

() {
  _timeit_now() {
    print -P '%D{%s.%.}' 2>/dev/null
  }

  _preexec_timeit() {
    _TIMEIT_START="$(_timeit_now)"
  }

  _precmd_timeit() {
    [ "$_TIMEIT_START" ] || return
    local DURATION="$(printf '%.3fs' $(($(_timeit_now) - _TIMEIT_START)))"
    printf '\e[%dC\e[1;31m%s\e[m\n' $((COLUMNS - ${#DURATION})) "$DURATION"
    unset _TIMEIT_START
  }

  enable_timeit() {
    autoload -U add-zsh-hook
    add-zsh-hook preexec _preexec_timeit
    add-zsh-hook precmd _precmd_timeit
  }

  disable_timeit() {
    autoload -U add-zsh-hook
    add-zsh-hook -d preexec _preexec_timeit
    add-zsh-hook -d precmd _precmd_timeit
  }
}

() {
  _str_() {
    printf '%s' "$@"
  }

  _prompt_fg() {
    local COLOR="$1" && shift
    _str_ "%{%F{$COLOR}%}" "$@"
  }

  _prompt_bg() {
    local COLOR="$1" && shift
    _str_ "%{%K{$COLOR}%}" "$@"
  }

  _prompt_bold() {
    _str_ '%{%B%}' "$@"
  }

  _prompt_inverse() {
    _str_ '%{%S%}' "$@"
  }

  _prompt_underline() {
    _str_ '%{%U%}' "$@"
  }

  _prompt_reset_color() {
    _str_ '%{%b%f%k%s%u%}' "$@"
  }

  _prompt_default_color() {
    local FG_COLOR="${THEME_DEFAULT_FG:+%F{$THEME_DEFAULT_FG\}}"
    local BG_COLOR="${THEME_DEFAULT_BG:+%K{$THEME_DEFAULT_BG\}}"
    _str_ "%{%B${FG_COLOR:-%f}${BG_COLOR:-%k}%s%u%}" "$@"
  }

  _prompt_space() {
    _prompt_default_color "$(printf "%$1s" ' ')"
  }

  _prompt_newline() {
    _prompt_default_color $'\n'
  }

  _prompt_anchor() {
    local FG_COLOR="${THEME_ANCHOR_FG:-blue}"
    _prompt_fg "$FG_COLOR" "$@"
  }

  _prompt_top_anchor() {
    _prompt_anchor '┌─'
  }

  _prompt_bottom_anchor() {
    _prompt_anchor '└─'
  }

  _prompt_bracket() {
    local FG_COLOR="${THEME_BRACKET_FG:-blue}"
    _prompt_fg "$FG_COLOR" '[' "$@"
    _prompt_fg "$FG_COLOR" ']'
  }

  _prompt_datetime() {
    local FG_COLOR="${THEME_DATETIME_FG:-yellow}"

    _prompt_datetime_d() {
      _prompt_fg "$FG_COLOR" '%D{%F %a %T %Z}'
    }

    _prompt_datetime_s() {
      _prompt_fg "$FG_COLOR" '%*'
    }

    if [ "$_THEME_USE_SIMPLE" ]; then
      _prompt_bracket "$(_prompt_datetime_s)"
    else
      _prompt_bracket "$(_prompt_datetime_d)"
    fi
  }

  _prompt_cwd() {
    local FG_COLOR="${THEME_WORKINGDIR_FG:-white}"

    _prompt_cwd_d() {
      _prompt_fg "$FG_COLOR" '%~'
    }

    _prompt_cwd_s() {
      _prompt_fg "$FG_COLOR" '%1~'
    }

    if [ "$_THEME_USE_SIMPLE" ]; then
      _prompt_bracket "$(_prompt_cwd_s)"
    else
      _prompt_bracket "$(_prompt_cwd_d)"
    fi
  }

  _prompt_git() {
    ((${+commands[git]})) || return
    $(git rev-parse --is-inside-work-tree >/dev/null 2>&1) || return
    if [ -e '.nogitprompt' ]; then
      return
    else
      local CDUP="$(git rev-parse --show-cdup 2>/dev/null)"
      if [ "$CDUP" ] && [ -e "$CDUP/.nogitprompt" ]; then
        return
      fi
    fi

    _prompt_git_ref() {
      local PL_BRANCH_CHAR=$'\ue0a0' # 
      local GIT_REF

      GIT_REF="$(git symbolic-ref HEAD 2>/dev/null)" || \
      GIT_REF="➦ $(git rev-parse --short HEAD 2>/dev/null)"
      GIT_REF="${GIT_REF/refs\/heads\//$PL_BRANCH_CHAR }"

      _str_ "$GIT_REF"
    }

    _prompt_git_info_msg() {
      autoload -Uz vcs_info
      zstyle ':vcs_info:*' enable git
      zstyle ':vcs_info:*' get-revision true
      zstyle ':vcs_info:*' formats ' %u%c'
      zstyle ':vcs_info:*' actionformats ' %u%c'
      if [ ! "$(git config --get oh-my-zsh.hide-dirty)" = '1' ]; then
        zstyle ':vcs_info:*' check-for-changes true
        zstyle ':vcs_info:*' check-for-staged-changes true
        zstyle ':vcs_info:*' stagedstr '✚ '
        zstyle ':vcs_info:*' unstagedstr '● '
      fi
      vcs_info

      local GIT_INFO_MSG="${vcs_info_msg_0_%% }"
      [ "$GIT_INFO_MSG" ] || return
      _str_ "$GIT_INFO_MSG "
    }

    _prompt_git_mode() {
      local REPO_PATH="$(git rev-parse --git-dir 2>/dev/null)"
      local GIT_MODE

      if [ -e "$REPO_PATH/BISECT_LOG" ]; then
        GIT_MODE=' <B>'
      elif [ -e "$REPO_PATH/MERGE_HEAD" ]; then
        GIT_MODE=' >M<'
      elif [ -e "$REPO_PATH/rebase" ] || \
           [ -e "$REPO_PATH/rebase-apply" ] || \
           [ -e "$REPO_PATH/rebase-merge" ]; then
        GIT_MODE=' >R>'
      fi

      [ "$GIT_MODE" ] || return
      _str_ "$GIT_MODE"
    }

    _prompt_git_d() {
      local FG_DIRTY="${THEME_VCSDIRTY_FG:-magenta}"
      local FG_CLEAN="${THEME_VCSCLEAN_FG:-green}"
      if [ "$(parse_git_dirty)" ]; then
        _prompt_fg "$FG_DIRTY"
      else
        _prompt_fg "$FG_CLEAN"
      fi

      _prompt_git_ref
      _prompt_git_info_msg
      _prompt_git_mode
    }

    if [ "$_THEME_USE_SIMPLE" ]; then
      return
    else
      _prompt_bracket "$(_prompt_git_d)"
    fi
  }

  _prompt_ret_status() {
    local FG_OK="${THEME_RETOK_FG:-green}"
    local FG_NG="${THEME_RETNG_FG:-red}"

    _prompt_emotion() {
      _prompt_fg "%(?:$FG_OK:$FG_NG)"
      _prompt_inverse '%(?:☺ :☹ )'
    }

    _prompt_retcode() {
      _prompt_fg "%(?:$FG_OK:$FG_NG)" '%?'
    }

    _prompt_ret_status_d() {
      _prompt_emotion
      _prompt_space
      _prompt_retcode
    }

    _prompt_ret_status_s() {
      _prompt_retcode
    }

    if [ "$_THEME_USE_SIMPLE" ]; then
      _prompt_ret_status_s
    else
      _prompt_bracket "$(_prompt_ret_status_d)"
    fi
  }

  _prompt_uid() {
    local FG_ROOT="${THEME_UIDSUPER_FG:-red}"
    local FG_USER="${THEME_UIDNORMAL_FG:-green}"
    _prompt_fg "%(!:$FG_ROOT:$FG_USER)" '%(!:#:$)'
  }

  _prompt_job() {
    local FG_COLOR="${THEME_JOBNUM_FG:-yellow}"

    _prompt_job_d() {
      _prompt_fg "$FG_COLOR" '⚙ x%j'
      _prompt_space
    }

    if [ "$_THEME_USE_SIMPLE" ]; then
      return
    else
      _str_ "%(1j.$(_prompt_job_d).)"
    fi
  }

  _prompt_histno() {
    local FG_COLOR="${THEME_HISTNO_FG:-black}"
    _prompt_fg "$FG_COLOR"
    _prompt_underline '!%!'
  }

  _prompt_client() {
    _prompt_ssh() {
      [ "$SSH_CONNECTION" ] || return
      local FG_COLOR="${THEME_SSHCONNECTION_FG:-red}"
      _prompt_fg "$FG_COLOR" 'ssh:'
    }

    _prompt_user() {
      local FG_COLOR="${THEME_USERNAME_FG:-green}"
      _prompt_fg "$FG_COLOR" '%n'
    }

    _prompt_at() {
      local FG_COLOR="${THEME_ATSIGN_FG:-black}"
      _prompt_fg "$FG_COLOR" '@'
    }

    _prompt_host() {
      local FG_COLOR="${THEME_HOSTNAME_FG:-cyan}"
      _prompt_fg "$FG_COLOR" '%m'
    }

    _prompt_logo() {
      local LOGO
      case "$OSTYPE" in
        darwin*) LOGO='' ;;
        linux*)
          case "$(lsb_release -s -i 2>/dev/null)" in
            'Ubuntu') LOGO='' ;;
            'CentOS') LOGO='※' ;;
            *) LOGO='🐧' ;;
          esac
          ;;
      esac

      [ "$LOGO" ] || return
      local FG_COLOR="${THEME_SYSLOGO_FG:-yellow}"
      _prompt_fg "$FG_COLOR" "$LOGO"
    }

    _prompt_line() {
      local FG_COLOR="${THEME_TERMLINE_FG:-magenta}"
      _prompt_fg "$FG_COLOR" '%y'
    }

    _prompt_client_d() {
      _prompt_ssh
      _prompt_user
      _prompt_at
      _prompt_host
      _prompt_logo
      _prompt_space
      _prompt_line
    }

    if [ "$_THEME_USE_SIMPLE" ]; then
      return
    else
      _prompt_bracket "$(_prompt_client_d)"
    fi
  }

  _build_lprompt_d() {
    setopt promptsubst

    _prompt_default_color
    _prompt_top_anchor
    _prompt_datetime
    _prompt_cwd
    _prompt_git
    _prompt_newline
    _prompt_bottom_anchor
    _prompt_ret_status
    _prompt_uid
    _prompt_space
    _prompt_reset_color
  }

  _build_lprompt_s() {
    setopt promptsubst

    _prompt_default_color
    _prompt_cwd
    _prompt_uid
    _prompt_space
    _prompt_reset_color
  }

  _build_lprompt() {
    if [ "$_THEME_USE_SIMPLE" ]; then
      _build_lprompt_s
    else
      _build_lprompt_d
    fi
  }

  _build_rprompt_d() {
    setopt transientrprompt

    _prompt_default_color
    _prompt_job
    _prompt_histno
    _prompt_space
    _prompt_client
    _prompt_reset_color
  }

  _build_rprompt_s() {
    setopt transientrprompt

    _prompt_default_color
    _prompt_ret_status
    _prompt_datetime
    _prompt_reset_color
  }

  _build_rprompt() {
    if [ "$_THEME_USE_SIMPLE" ]; then
      _build_rprompt_s
    else
      _build_rprompt_d
    fi
  }
}

setup_theme() {
  : "${THEME_DEFAULT_FG:=white}"
  : "${THEME_DEFAULT_BG:=}"
  : "${THEME_MIN_LINES:=10}"
  : "${THEME_MIN_COLUMNS:=50}"

  if [ "$THEME_DISABLE_TIMEIT" ] || \
     [ "$LINES" -lt "$THEME_MIN_LINES" ]; then
    disable_timeit
  else
    enable_timeit
  fi

  unset _THEME_USE_SIMPLE
  if [ "$THEME_MINIMAL" ] || \
     [ "$THEME_DISABLE_MULTILINE" ] || \
     [ "$LINES" -lt "$THEME_MIN_LINES" ] || \
     [ "$COLUMNS" -lt "$THEME_MIN_COLUMNS" ]; then
    _THEME_USE_SIMPLE=1
  fi

  PROMPT='$(_build_lprompt)'
  if [ "$THEME_DISABLE_RPROMPT" ]; then
    RPROMPT=
  else
    RPROMPT='$(_build_rprompt)'
  fi
}

trap 'setup_theme' WINCH
setup_theme
