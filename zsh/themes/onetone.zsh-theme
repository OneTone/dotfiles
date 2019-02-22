# vim: ft=zsh ts=2 sw=2 sts=2 et

_build_prompt() {
  _join_str() {
    printf '%s' "$@"
  }

  _prompt_fg() {
    _join_str "%{%F{$1}%}"
  }

  _prompt_bg() {
    _join_str "%{%K{$1}%}"
  }

  _prompt_bold() {
    _join_str $'%{%B%}'
  }

  _prompt_inverse() {
    _join_str $'%{%S%}'
  }

  _prompt_underline() {
    _join_str $'%{%U%}'
  }

  _prompt_reset_color() {
    _join_str $'%{%b%f%k%s%u%}'
  }

  _prompt_default_color() {
    local FG_COLOR="${PROMPT_DEFAULT_FG:+%F{$PROMPT_DEFAULT_FG\}}"
    local BG_COLOR="${PROMPT_DEFAULT_BG:+%K{$PROMPT_DEFAULT_BG\}}"
    : "${FG_COLOR:-%f}"
    : "${BG_COLOR:-%k}"
    _join_str "%{%B$FG_COLOR$BG_COLOR%s%u%}"
  }

  _prompt_space() {
    local SPACE_COLOR="$(_prompt_default_color)"
    printf "%s%$1s" "$SPACE_COLOR" ' '
  }

  _prompt_newline() {
    local LN_COLOR="$(_prompt_default_color)"
    printf "%s\n" "$LN_COLOR"
  }

  () {
    _prompt_anchor() {
      local ANCHOR_COLOR="$(_prompt_fg 'blue')"
      _join_str "$ANCHOR_COLOR" "$@"
    }

    _prompt_top_anchor() {
      _prompt_anchor '┌─'
    }

    _prompt_bottom_anchor() {
      _prompt_anchor '└─'
    }
  }

  _prompt_bracket() {
    local BRACKET_COLOR="$(_prompt_fg 'blue')"
    printf '%s[%s%s]' "$BRACKET_COLOR" "$(_join_str "$@")" "$BRACKET_COLOR"
  }

  _prompt_datetime() {
    local DATETIME_COLOR="$(_prompt_fg 'yellow')"
    _prompt_bracket "$DATETIME_COLOR" $'%D{%F %a %T %Z}'
  }

  _prompt_cwd() {
    local CWD_COLOR="$(_prompt_fg 'white')"
    _prompt_bracket "$CWD_COLOR" $'%~'
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

      _join_str "$GIT_REF"
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
      [[ -n "$GIT_INFO_MSG" ]] || return
      _join_str "$GIT_INFO_MSG" ' '
    }

    _prompt_git_mode() {
      local REPO_PATH="$(git rev-parse --git-dir 2>/dev/null)"
      local GIT_MODE

      if [[ -e "${REPO_PATH}/BISECT_LOG" ]]; then
        GIT_MODE=' <B>'
      elif [[ -e "${REPO_PATH}/MERGE_HEAD" ]]; then
        GIT_MODE=' >M<'
      elif [[ -e "${REPO_PATH}/rebase" || \
              -e "${repo_path}/rebase-apply" || \
              -e "${repo_path}/rebase-merge" || \
              -e "${repo_path}/../.dotest" ]]; then
        GIT_MODE=' >R>'
      fi

      [[ -n "$GIT_MODE" ]] || return
      _join_str "$GIT_MODE"
    }

    _prompt_git_d() {
      if [[ -n "$(parse_git_dirty)" ]]; then
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
      local EMOTION_COLOR="$(_prompt_fg '%(?:green:red)')$(_prompt_inverse)"
      _join_str "$EMOTION_COLOR" $'%(?:☺ :☹ )'
    }

    _prompt_retcode() {
      local RETCODE_COLOR="$(_prompt_fg '%(?:green:red)')"
      _join_str "$RETCODE_COLOR" $'%?'
    }

    _prompt_ret_status_d() {
      _prompt_emotion
      _prompt_space
      _prompt_retcode
    }

    _prompt_bracket "$(_prompt_ret_status_d)"
  }

  _prompt_uid() {
    local UID_COLOR="$(_prompt_fg $'%(!:red:green)')"
    _join_str "$UID_COLOR" $'%(!:#:$)'
  }

  _prompt_job() {
    [[ "$(jobs -l | wc -l)" -gt 0 ]] || return
    local JOB_COLOR="$(_prompt_fg 'yellow')"
    _join_str "$JOB_COLOR" $'⚙ x%j' "$(_prompt_space)"
  }

  _prompt_histno() {
    local HISTNO_COLOR="$(_prompt_fg 'black')$(_prompt_underline)"
    _join_str "$HISTNO_COLOR" $'!%!'
  }

  _prompt_client() {
    _prompt_ssh() {
      [[ -n "$SSH_CONNECTION" ]] || return
      local SSH_COLOR="$(_prompt_fg 'red')"
      _join_str "$SSH_COLOR" 'ssh:'
    }

    _prompt_user() {
      local USER_COLOR="$(_prompt_fg 'green')"
      _join_str "$USER_COLOR" $'%n'
    }

    _prompt_at() {
      local AT_COLOR="$(_prompt_fg 'black')"
      _join_str "$AT_COLOR" '@'
    }

    _prompt_host() {
      local HOST_COLOR="$(_prompt_fg 'cyan')"
      _join_str "$HOST_COLOR" $'%m'
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

      [[ -n "$LOGO" ]] || return

      local LOGO_COLOR="$(_prompt_fg 'yellow')"
      _join_str "$LOGO_COLOR" "$LOGO"
    }

    _prompt_line() {
      local LINE_COLOR="$(_prompt_fg 'magenta')"
      _join_str "$LINE_COLOR" '%y'
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

  case "$1" in
    [rR]) _build_rprompt ;;
    *) _build_lprompt ;;
  esac
}

: "${PROMPT_DEFAULT_FG:=white}"
: "${PROMPT_DEFAULT_BG:=}"

PROMPT='$(_build_prompt) '
RPROMPT='$(_build_prompt r)'
