# shellcheck shell=bash
# shellcheck disable=SC1091,SC1090
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source /etc/os-release

# Editor & prompt configuration
[ -f "$HOME/.bashrc.d/editor" ] && source "$HOME/.bashrc.d/editor"
[ -f "$HOME/.bashrc.d/prompt" ] && source "$HOME/.bashrc.d/prompt"

# Aliases {{{
# Load aliases dynamically
[ -f "$HOME/.bash_aliases/all" ] && source "$HOME/.bash_aliases/all"
[ -f "$HOME/.bash_aliases/hosts/$HOSTNAME" ] && source "$HOME/.bash_aliases/hosts/$HOSTNAME"
[ -f "$HOME/.bash_aliases/private" ] && source "$HOME/.bash_aliases/private"

# Host-specific and private configurations
[ -f "$HOME/.bashrc.d/hosts/$HOSTNAME" ] && source "$HOME/.bashrc.d/hosts/$HOSTNAME"
[ -f "$HOME/.bashrc.d/private" ] && source "$HOME/.bashrc.d/private"
# }}}

# Prompt {{{
[ -f "$HOME/.bashrc.d/prompt" ] && source "$HOME/.bashrc.d/prompt"
# }}}

# Path {{{
# Add ~/.bin to PATH
export PATH=~/.bin:$PATH
# }}}

# History {{{
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=500000
# Omit `clear, ls...`; commands prepended with space
export HISTIGNORE="clear:l: *"
# }}}

# Man pages {{{
# See `:h :Man` in NeoVim
export MANWIDTH=80
export PAGER=nvimpager
# }}}

# Nvm
export PATH=~/.nvm/versions/node/v14.16.0/bin:$PATH
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use

# X11 {{{
export XDG_SESSION_TYPE=X11
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
# }}}

# Nix package manager {{{
# Add ~/.nix-profile/bin to PATH
export PATH=~/.nix-profile/bin:$PATH
# }}}

# FZF {{{
# Check if fzf is installed
if [ -f "/usr/bin/fzf" ]; then
  # Fuzzy finder setup
  export FZF_COMPLETION_TRIGGER='**'
  export FZF_DEFAULT_COMMAND='ag --hidden --skip-vcs-ignores -t -g ""'
  export FZF_DEFAULT_OPTS="
  --pointer='❭'
  --height 10%
  --color=fg:-1,bg:-1"
  export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
  export FZF_CTRL_T_OPTS="--preview='bat {} | head -500'"

  if [[ $ID == "raspbian" ]]; then
    source /usr/share/doc/fzf/examples/completion.bash
    source /usr/share/doc/fzf/examples/key-bindings.bash
  elif [[ $ID == "arch" ]]; then
    source /usr/share/fzf/completion.bash
    source /usr/share/fzf/key-bindings.bash
  fi

  _fzf_setup_completion path vim zathura xournalpp nvim mpv
else
  echo "fzf not installed"
fi
# }}}

# Node {{{
# Move nvm folder away from home directory
export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
# Pretty much what is in `/usr/share/nvm/init-nvm.sh` but we add the `--no-use`
# flag to `nvm.sh` to make it lazy
source /usr/share/nvm/nvm.sh --no-use
source /usr/share/nvm/bash_completion
source /usr/share/nvm/install-nvm-exec
# }}}

# Go {{{
export GOPATH="${XDG_DATA_HOME}/go"
# }}}

# Jupyter {{{
export JUPYTERLAB_DIR=$HOME/.local/share/jupyter/lab
# }}}

# Conda {{{
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
# }}}

# Zettelkasten {{{
export ZK_PATH="$HOME/.zk"
