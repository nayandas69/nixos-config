# ============================================================================
# home/default.nix - Home-Manager Entry Point
# ============================================================================
# Imports ALL modules unconditionally. Each module uses mkIf internally
# to enable/disable itself based on the my.* toggle options.
# ============================================================================
{ config, pkgs, lib, isDarwin ? false, wsl ? false, user ? "nayandas", ... }:

let
  homeDir = if isDarwin then "/Users/${user}" else "/home/${user}";
in
{
  imports = [
    # -- Custom options definition ------------------------------------------
    ../modules/options.nix

    # -- Shell & prompt (always) --------------------------------------------
    ./shell/zsh.nix
    ./shell/starship.nix
    ./shell/aliases.nix

    # -- Git (always) -------------------------------------------------------
    ./git.nix

    # -- CLI tools (always) -------------------------------------------------
    ./programs.nix

    # -- Tmux (always) ------------------------------------------------------
    ./terminal/tmux.nix

    # -- Editors (conditional via mkIf inside each file) --------------------
    ./editors/neovim.nix
    ./editors/helix.nix
    ./editors/vscode.nix

    # -- Dev toolchains (conditional via mkIf inside each file) -------------
    ./dev/nodejs.nix
    ./dev/python.nix
    ./dev/rust.nix
    ./dev/go.nix
    ./dev/devops.nix

    # -- GUI apps (conditional via mkIf inside each file) -------------------
    ./browsers.nix
    ./media.nix
    ./terminal/alacritty.nix
  ];

  # -- Home-Manager core settings -------------------------------------------
  home = {
    username = user;
    homeDirectory = homeDir;
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
