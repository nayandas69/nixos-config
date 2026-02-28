# ============================================================================
# home/terminal/tmux.nix - Tmux Terminal Multiplexer
# ============================================================================
# Tmux config that licks terminal sessions into persistent, split-pane,
# multi-window productivity. Prefix is Ctrl+a (screen-style), mouse mode
# is on, and vi keybindings are used throughout.
# ============================================================================
{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;

    # -- Core settings ------------------------------------------------------
    prefix = "C-a";        # Ctrl+a instead of default Ctrl+b
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;         # start window numbering at 1 (not 0)
    escapeTime = 0;        # no delay after pressing Escape
    historyLimit = 50000;  # generous scrollback buffer
    clock24 = true;

    # -- Plugins ------------------------------------------------------------
    plugins = with pkgs.tmuxPlugins; [
      sensible       # sensible defaults everyone agrees on
      yank           # copy to system clipboard
      resurrect      # save/restore sessions across restarts
      continuum      # auto-save sessions every 15 minutes
      catppuccin     # Catppuccin theme to match everything else
    ];

    # -- Extra configuration ------------------------------------------------
    extraConfig = ''
      # -- Splits that lick window management into intuition ----------------
      # Use | and - for splits (easier to remember than % and ")
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # New windows open in the current directory
      bind c new-window -c "#{pane_current_path}"

      # -- Pane navigation (vim-style) --------------------------------------
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Alt+arrow for pane switching without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # -- Pane resizing (prefix + H/J/K/L) --------------------------------
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # -- Quick reload config -----------------------------------------------
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"

      # -- Visual tweaks ----------------------------------------------------
      set -g focus-events on
      set -g status-position top

      # True color support
      set -as terminal-features ',xterm-256color:RGB'
      set -g default-terminal "tmux-256color"

      # -- Catppuccin theme settings ----------------------------------------
      set -g @catppuccin_flavor "mocha"
      set -g @catppuccin_window_status_style "rounded"

      # -- Resurrect & Continuum settings -----------------------------------
      # Licks session persistence into automatic habit
      set -g @resurrect-capture-pane-contents 'on'
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'
    '';
  };
}
