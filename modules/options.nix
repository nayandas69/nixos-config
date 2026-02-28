# ============================================================================
# modules/options.nix - Feature Toggle Options
# ============================================================================
# Custom NixOS/home-manager options that let each host (or local config)
# pick exactly which dev toolchains, editors, and GUI apps to install.
#
# Usage in your host config or local-config.nix:
#   my.dev.nodejs.enable = true;
#   my.dev.rust.enable  = false;
#   my.gui.browsers.enable = true;
# ============================================================================
{ config, lib, ... }:

let
  inherit (lib) mkEnableOption;
in
{
  options.my = {

    # -- Dev toolchains -----------------------------------------------------
    dev = {
      nodejs.enable  = mkEnableOption "Node.js, npm, pnpm, Bun, Deno, TypeScript";
      python.enable  = mkEnableOption "Python 3, Poetry, Black, Ruff, mypy";
      rust.enable    = mkEnableOption "Rust compiler, Cargo, clippy, rust-analyzer";
      go.enable      = mkEnableOption "Go compiler, gopls, golangci-lint, delve";
      devops.enable  = mkEnableOption "Terraform, Ansible, Kubernetes, Docker tools";
    };

    # -- Editors ------------------------------------------------------------
    editors = {
      vscode.enable  = mkEnableOption "Visual Studio Code with extensions";
      neovim.enable  = mkEnableOption "Neovim with LSP and plugin config";
      helix.enable   = mkEnableOption "Helix editor";
    };

    # -- GUI apps (only relevant on graphical hosts) ------------------------
    gui = {
      browsers.enable = mkEnableOption "Firefox and Chromium";
      media.enable    = mkEnableOption "Spotify, VLC, OBS, Discord, etc.";
      alacritty.enable = mkEnableOption "Alacritty terminal emulator";
    };
  };
}
