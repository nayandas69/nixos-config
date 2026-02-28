# ============================================================================
# home/programs.nix - CLI Power Tools
# ============================================================================
# The Swiss army knife of command-line utilities that licks your terminal
# workflow into peak productivity. Modern replacements for classic tools
# plus essential utilities every developer needs.
# ============================================================================
{ config, pkgs, lib, ... }:

{
  # -- bat (cat replacement) ------------------------------------------------
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin Mocha";
      style = "numbers,changes,header";
      pager = "less -FR";
    };
  };

  # -- eza (ls replacement) -------------------------------------------------
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    enableZshIntegration = false; # we define our own aliases
  };

  # -- fd (find replacement) ------------------------------------------------
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [ ".git/" "node_modules/" "target/" "__pycache__/" ];
  };

  # -- fzf (fuzzy finder) ---------------------------------------------------
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];
    # Catppuccin Mocha colors for fzf
    colors = {
      "bg+" = "#313244";
      "bg" = "#1e1e2e";
      "spinner" = "#f5e0dc";
      "hl" = "#f38ba8";
      "fg" = "#cdd6f4";
      "header" = "#f38ba8";
      "info" = "#cba6f7";
      "pointer" = "#f5e0dc";
      "marker" = "#f5e0dc";
      "fg+" = "#cdd6f4";
      "prompt" = "#cba6f7";
      "hl+" = "#f38ba8";
    };
  };

  # -- ripgrep (grep replacement) -------------------------------------------
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--hidden"
      "--glob=!.git/"
      "--glob=!node_modules/"
      "--glob=!target/"
    ];
  };

  # -- direnv (per-directory environments) ----------------------------------
  # Licks project-specific env vars and nix shells into auto-loading magic
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true; # faster nix shell loading
  };

  # -- htop (process viewer) ------------------------------------------------
  programs.htop = {
    enable = true;
    settings = {
      show_program_path = false;
      highlight_base_name = true;
      tree_view = true;
    };
  };

  # -- zoxide (smart cd) ---------------------------------------------------
  # Learns your most-used directories and licks `cd` into a smart jump
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # -- jq (JSON processor) -------------------------------------------------
  programs.jq.enable = true;

  # -- Additional CLI tools -------------------------------------------------
  # Everything else that licks the terminal into a complete toolkit
  home.packages = with pkgs; [
    # File & text tools
    tree           # directory tree view
    watch          # run a command repeatedly
    entr           # run commands on file changes
    sd             # sed alternative
    choose         # cut alternative
    procs          # ps alternative
    dust           # du alternative (disk usage)
    duf            # df alternative (disk free)
    tokei          # code statistics
    hyperfine      # command benchmarking

    # Network tools
    curl
    wget
    httpie         # user-friendly HTTP client
    xh             # even faster httpie alternative
    dog            # dig alternative (DNS lookup)

    # Archive tools
    unzip
    p7zip
    gzip
    gnutar

    # System tools
    file
    which
    lsof
    strace
    pciutils       # lspci
    usbutils       # lsusb
    killall

    # Clipboard (for Linux desktops)
    xclip
    wl-clipboard

    # Misc dev tools
    sqlite         # SQLite CLI
    jc             # JSON output for common commands
    glow           # terminal markdown viewer
    nix-output-monitor  # prettier nix build output
    nixfmt-rfc-style    # nix formatter
    statix              # nix linter

    # Fun / useful
    neofetch       # system info in style
    cowsay         # because why not
    tldr           # simplified man pages
  ];
}
