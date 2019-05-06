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
    printf '\e[%dC\e[1;31m%s\e[m\n' $((COLUMNS - ${#DURATION} - 1)) "$DURATION"
    unset _TIMEIT_START
  }

  autoload -U add-zsh-hook
  add-zsh-hook preexec _preexec_timeit
  add-zsh-hook precmd _precmd_timeit
}

() {
  _str_() {
    printf '%s' "$@"
  }

  _prompt_fg() {
    local COLOR="$1"
    shift
    _str_ "%{%F{$COLOR}%}" "$@"
  }

  _prompt_bg() {
    local COLOR="$1"
    shift
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
    local FG_COLOR="${PROMPT_DEFAULT_FG:+%F{$PROMPT_DEFAULT_FG\}}"
    local BG_COLOR="${PROMPT_DEFAULT_BG:+%K{$PROMPT_DEFAULT_BG\}}"
    : "${FG_COLOR:-%f}"
    : "${BG_COLOR:-%k}"
    _str_ "%{%B$FG_COLOR$BG_COLOR%s%u%}" "$@"
  }

  _prompt_space() {
    _prompt_default_color "$(printf "%$1s" ' ')"
  }

  _prompt_newline() {
    _prompt_default_color $'\n'
  }

  _prompt_anchor() {
    _prompt_fg 'blue' "$@"
  }

  _prompt_top_anchor() {
    _prompt_anchor '┌─'
  }

  _prompt_bottom_anchor() {
    _prompt_anchor '└─'
  }

  _prompt_bracket() {
    _prompt_fg 'blue' '[' "$@"
    _prompt_fg 'blue' ']'
  }

  _prompt_datetime() {
    _prompt_datetime_d() {
      _prompt_fg 'yellow' '%D{%F %a %T %Z}'
    }

    _prompt_bracket "$(_prompt_datetime_d)"
  }

  _prompt_cwd() {
  _prompt_cwd_d() {
      _prompt_fg 'white' '%~'
    }

  _prompt_bracket "$(_prompt_cwd_d)"
  }

  _prompt_git() {
    ((${+commands[git]})) || return
    $(git rev-parse --is-inside-work-tree >/dev/null 2>&1) || return

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
      zstyle ':vcs_info:*' check-for-changes true
      zstyle ':vcs_info:*' stagedstr '✚ '
      zstyle ':vcs_info:*' unstagedstr '● '
      zstyle ':vcs_info:*' formats ' %u%c'
      zstyle ':vcs_info:*' actionformats ' %u%c'
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
           [ -e "$REPO_PATH/rebase-merge" ] || \
           [ -e "$REPO_PATH/../.dotest" ]; then
        GIT_MODE=' >R>'
      fi

      [ "$GIT_MODE" ] || return
      _str_ "$GIT_MODE"
    }

    _prompt_git_d() {
      if [ "$(parse_git_dirty)" ]; then
        _prompt_fg 'magenta'
      else
        _prompt_fg 'green'
      fi

      _prompt_git_ref
      _prompt_git_info_msg
      _prompt_git_mode
    }

    _prompt_bracket "$(_prompt_git_d)"
  }

  _prompt_ret_status() {
    _prompt_emotion() {
      _prompt_fg '%(?:green:red)'
      _prompt_inverse '%(?:☺ :☹ )'
    }

    _prompt_retcode() {
      _prompt_fg '%(?:green:red)' '%?'
    }

    _prompt_ret_status_d() {
      _prompt_emotion
      _prompt_space
      _prompt_retcode
    }

    _prompt_bracket "$(_prompt_ret_status_d)"
  }

  _prompt_uid() {
    _prompt_fg '%(!:red:green)' '%(!:#:$)'
  }

  _prompt_job() {
    _prompt_job_d() {
      _prompt_fg 'yellow' '⚙ x%j'
      _prompt_space
    }

    _str_ "%(1j.$(_prompt_job_d).)"
  }

  _prompt_histno() {
    _prompt_fg 'black'
    _prompt_underline '!%!'
  }

  _prompt_client() {
    _prompt_ssh() {
      [ "$SSH_CONNECTION" ] || return
      _prompt_fg 'red' 'ssh:'
    }

    _prompt_user() {
      _prompt_fg 'green' '%n'
    }

    _prompt_at() {
      _prompt_fg 'black' '@'
    }

    _prompt_host() {
      _prompt_fg 'cyan' '%m'
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

      _prompt_fg 'yellow' "$LOGO"
    }

    _prompt_line() {
      _prompt_fg 'magenta' '%y'
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

    _prompt_bracket "$(_prompt_client_d)"
  }

  _build_lprompt() {
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

  _build_rprompt() {
    setopt transientrprompt

    _prompt_default_color
    _prompt_job
    _prompt_histno
    _prompt_space
    _prompt_client
    _prompt_reset_color
  }

  : "${PROMPT_DEFAULT_FG:=white}"
  : "${PROMPT_DEFAULT_BG:=}"

  PROMPT='$(_build_lprompt)'
  RPROMPT='$(_build_rprompt)'
}
