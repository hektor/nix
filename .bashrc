# shellcheck shell=bash
# shellcheck disable=SC1091,SC1090
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

. /etc/os-release

# Editor & prompt configuration
[ -f "$HOME/.bashrc.d/editor" ] && . "$HOME/.bashrc.d/editor"
[ -f "$HOME/.bashrc.d/prompt" ] && . "$HOME/.bashrc.d/prompt"

# Aliases {{{
# Load aliases dynamically
[ -f "$HOME/.bash_aliases/all" ] && . "$HOME/.bash_aliases/all"
[ -f "$HOME/.bash_aliases/hosts/$HOSTNAME" ] && . "$HOME/.bash_aliases/hosts/$HOSTNAME"
[ -f "$HOME/.bash_aliases/private" ] && . "$HOME/.bash_aliases/private"
[ -f "$HOME/.bash_aliases/lang-js" ] && . "$HOME/.bash_aliases/lang-js"
command -v jira >/dev/null && [ -f "$HOME/.bash_aliases/jira" ] && . "$HOME/.bash_aliases/jira"

# Completions {{{
[ -d "$HOME/.bash_completions" ] && for file in "$HOME/.bash_completions"/*; do
  [ -f "$file" ] && . "$file"
done
# }}}

# Host-specific and private configurations
[ -f "$HOME/.bashrc.d/hosts/$HOSTNAME" ] && . "$HOME/.bashrc.d/hosts/$HOSTNAME"
[ -f "$HOME/.bashrc.d/private" ] && . "$HOME/.bashrc.d/private"
# }}}

# Prompt {{{
[ -f "$HOME/.bashrc.d/prompt" ] && . "$HOME/.bashrc.d/prompt"
# }}}

# Path {{{
# Add ~/.bin to PATH
export PATH=~/.bin:$PATH
# }}}

# History {{{
export HISTSIZE=999999
export HISTFILESIZE= # Unlimited
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE=" *:clear:l:ls:cd" # Omit commands from history (e.g. those prepended with space)
# }}}

# Man pages {{{
# See `:h :Man` in NeoVim
export MANWIDTH=80
export PAGER=nvimpager
# }}}

# X11 {{{
export XDG_SESSION_TYPE=X11
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
# }}}

# FZF {{{
# Check if fzf is installed
if [ -f "/usr/bin/fzf" ]; then
  # Fuzzy finder setup
  export FZF_COMPLETION_TRIGGER='**'
  export FZF_DEFAULT_COMMAND='ag -g ""'
  export FZF_DEFAULT_OPTS="
  --pointer='❭'
  --height 10%
  --color=fg:-1,bg:-1"
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
  export FZF_CTRL_T_OPTS="--preview='bat {} | head -500'"

  if [[ $ID == "raspbian" ]]; then
    . /usr/share/doc/fzf/examples/completion.bash
    . /usr/share/doc/fzf/examples/key-bindings.bash
  elif [[ $ID == "arch" ]]; then
    . /usr/share/fzf/completion.bash
    . /usr/share/fzf/key-bindings.bash
  fi

  _fzf_setup_completion path vim zathura xournalpp nvim mpv
else
  echo "fzf not installed"
fi
# }}}

# Go {{{
export GOPATH="${XDG_DATA_HOME}/go"
# }}}

# Jupyter {{{
export JUPYTERLAB_DIR=$HOME/.local/share/jupyter/lab
# }}}

# Conda {{{
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && . /opt/miniconda3/etc/profile.d/conda.sh
# }}}

# Zettelkasten {{{
export ZK_PATH="$HOME/.zk"

# SSH Agent {{{
if [[ -z "${SSH_CONNECTION}" ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi
# }}}

# pnpm
export PNPM_HOME="/home/h/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Codi
# Usage: codi [filetype] [filename]
codi() {
  local syntax="${1:-python}"
  shift
  nvim -c \
    "let g:startify_disable_at_vimenter = 1 |\
    set bt=nofile ls=0 noru nonu nornu |\
    hi ColorColumn ctermbg=NONE |\
    hi VertSplit ctermbg=NONE |\
    hi NonText ctermfg=0 |\
    Codi $syntax" "$@"
}
