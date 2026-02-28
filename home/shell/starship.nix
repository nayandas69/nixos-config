# ============================================================================
# home/shell/starship.nix - Starship Prompt Configuration
# ============================================================================
# A blazing-fast cross-shell prompt that licks every context indicator
# (git branch, node version, python venv, etc.) into the terminal in
# milliseconds. Powered by Rust.
# ============================================================================
{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    # -- Prompt config (TOML) -----------------------------------------------
    settings = {
      # Prompt format - clean and informative
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$nodejs"
        "$python"
        "$rust"
        "$golang"
        "$docker_context"
        "$kubernetes"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      # -- Character --------------------------------------------------------
      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[x](bold red)";
        vimcmd_symbol = "[<](bold cyan)";
      };

      # -- Directory --------------------------------------------------------
      directory = {
        truncation_length = 4;
        truncation_symbol = ".../";
        style = "bold cyan";
      };

      # -- Git branch -------------------------------------------------------
      git_branch = {
        symbol = " ";
        style = "bold purple";
        truncation_length = 30;
      };

      # -- Git status -------------------------------------------------------
      git_status = {
        style = "bold red";
        conflicted = "!";
        ahead = "^";
        behind = "v";
        diverged = "^v";
        untracked = "?";
        stashed = "$";
        modified = "~";
        staged = "+";
        renamed = "r";
        deleted = "-";
      };

      # -- Language contexts ------------------------------------------------
      # Each one licks the active version into the prompt when detected
      nodejs = {
        symbol = " ";
        style = "bold green";
        detect_files = [ "package.json" ".node-version" ];
      };

      python = {
        symbol = " ";
        style = "bold yellow";
        detect_files = [ "pyproject.toml" "requirements.txt" ".python-version" ];
      };

      rust = {
        symbol = " ";
        style = "bold orange";
        detect_files = [ "Cargo.toml" ];
      };

      golang = {
        symbol = " ";
        style = "bold blue";
        detect_files = [ "go.mod" ];
      };

      # -- Docker context ---------------------------------------------------
      docker_context = {
        symbol = " ";
        style = "bold blue";
        only_with_files = true;
        detect_files = [ "Dockerfile" "docker-compose.yml" "docker-compose.yaml" ];
      };

      # -- Kubernetes -------------------------------------------------------
      kubernetes = {
        disabled = false;
        symbol = "k8s ";
        style = "bold blue";
      };

      # -- Nix shell --------------------------------------------------------
      nix_shell = {
        symbol = " ";
        style = "bold blue";
        format = "via [$symbol$state]($style) ";
      };

      # -- Command duration -------------------------------------------------
      # Shows how long the last command took (if >2 seconds)
      cmd_duration = {
        min_time = 2000; # ms
        format = "took [$duration](bold yellow) ";
      };

      # -- Username & hostname (show in SSH sessions) -----------------------
      username = {
        show_always = false;
        style_user = "bold green";
        format = "[$user]($style)@";
      };

      hostname = {
        ssh_only = true;
        style = "bold green";
        format = "[$hostname]($style) in ";
      };
    };
  };
}
