# ============================================================================
# hosts/wsl/default.nix - Windows Subsystem for Linux Configuration
# ============================================================================
# Headless NixOS inside WSL2. No desktop environment here - this licks the
# terminal-only workflow into a fast, lightweight dev box that talks to
# Windows seamlessly. GUI apps can still run via WSLg if needed.
#
# Rebuild with:
#   sudo nixos-rebuild switch --flake .#wsl
# ============================================================================
{ config, pkgs, lib, user, wsl, ... }:

{
  imports = [
    # Shared NixOS modules (no desktop or virtualization needed)
    ../../modules/core.nix
    ../../modules/networking.nix
    ../../modules/services.nix
  ];

  # -- WSL-specific settings ------------------------------------------------
  # NixOS-WSL licks the integration layer into place
  wsl = {
    enable = true;
    defaultUser = user;
    startMenuLaunchers = true;

    # Mount Windows drives under /mnt/
    wslConf.automount.root = "/mnt";
    wslConf.automount.enabled = true;

    # Interop lets you call Windows executables from Linux
    wslConf.interop.enabled = true;
    wslConf.interop.appendWindowsPath = true;
  };

  # -- Hostname -------------------------------------------------------------
  networking.hostName = "nayandas-wsl";

  # -- User account ---------------------------------------------------------
  users.users.${user} = {
    isNormalUser = true;
    description = "Nayan Das";
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    initialPassword = "changeme";
  };

  programs.zsh.enable = true;

  # -- System packages ------------------------------------------------------
  # Keep it lean - most tools live in home-manager
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    htop
    wslu # WSL utilities (wslopen, wslpath, etc.)
  ];

  # -- Docker in WSL -------------------------------------------------------
  # If you use Docker Desktop on Windows, you may want to disable this
  # and let Docker Desktop handle the daemon via WSL integration instead.
  virtualisation.docker.enable = true;

  # -- State version --------------------------------------------------------
  system.stateVersion = "25.11";
}
