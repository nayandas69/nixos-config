# ============================================================================
# home/shell/zsh.nix - Zsh Configuration
# ============================================================================
# Licks Zsh into a feature-rich, fast shell with oh-my-zsh, autosuggestions,
# syntax highlighting, and vi-mode. The starship prompt is handled in a
# separate file.
# ============================================================================
{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh"; # keep ~ clean

    # -- History settings ---------------------------------------------------
    # Large, deduplicated history that licks repeated commands away
    history = {
      size = 50000;
      save = 50000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      extended = true;
      share = true; # share history across terminals
    };

    # -- Completions --------------------------------------------------------
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # -- Oh-My-Zsh ----------------------------------------------------------
    # The plugin framework that licks Zsh into a productivity beast
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"              # git aliases and completions
        "docker"           # docker completions
        "docker-compose"   # docker-compose completions
        "kubectl"          # kubernetes completions
        "fzf"              # fuzzy finder integration
        "z"                # smart directory jumping
        "sudo"             # press ESC twice to prepend sudo
        "extract"          # extract any archive format
        "colored-man-pages"
        "command-not-found"
      ];
    };

    # -- Shell options ------------------------------------------------------
    initContent = ''
      # Vi mode - licks modal editing into the shell
      bindkey -v
      export KEYTIMEOUT=1

      # Better vi mode indicators
      function zle-keymap-select {
        case $KEYMAP in
          vicmd) echo -ne '\e[1 q' ;; # block cursor for normal mode
          viins|main) echo -ne '\e[5 q' ;; # beam cursor for insert mode
        esac
      }
      zle -N zle-keymap-select

      # Start in insert mode
      echo -ne '\e[5 q'

      # Ctrl+R for fzf history search (works alongside vi mode)
      bindkey '^R' history-incremental-search-backward

      # Home/End keys
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
      bindkey '^[[3~' delete-char

      # Auto-ls after cd
      function chpwd() {
        ls --color=auto
      }

      # direnv hook - licks per-directory environments into existence
      eval "$(direnv hook zsh)"
    '';

    # -- Session variables --------------------------------------------------
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less -R";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };
  };
}
