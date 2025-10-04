# This file is based on the one provided by shipwright.nvim
set -g @FG '#dddddd'
set -g @BG '#111111'

set -g status-left ' #[fg=#{@FG},bold]#{s/root//:client_key_table} '
set -g status-right '#[fg=#{@FG},bold] [#S]#[fg=#{@FG},bold] [%d/%m] #[fg=#{@FG},bold][%I:%M%p] '
set -g status-style fg='#{@FG}',bg='#{@BG}'

set -g window-status-current-style fg='#{@FG}',bg='#{@BG}',bold

set -g pane-border-style fg='#{@FG}'
set -g pane-active-border-style fg='#{@FG}'

set -g message-style fg='#{@FG}',bg='#{@FG}'

set -g display-panes-active-colour '#{@FG}'
set -g display-panes-colour '#{@FG}'

set -g clock-mode-colour '#{@FG}'

set -g mode-style fg='#{@FG}',bg='#{@FG}'

