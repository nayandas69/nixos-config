# ============================================================================
# hosts/vmware/default.nix - VMware Virtual Machine Configuration
# ============================================================================
# This licks the VMware guest into a usable Cinnamon desktop. Includes
# open-vm-tools for clipboard sharing, drag-and-drop, and auto-resize.
#
# Rebuild with:
#   sudo nixos-rebuild switch --flake .#vmware
# ============================================================================
{ config, pkgs, lib, user, ... }:

{
  imports = [
    # Hardware config specific to the VM
    ./hardware-configuration.nix

    # Shared NixOS modules
    ../../modules/core.nix
    ../../modules/desktop/cinnamon.nix
    ../../modules/networking.nix
    ../../modules/virtualization.nix
    ../../modules/services.nix
  ];

  # -- Hostname -------------------------------------------------------------
  networking.hostName = "nayandas-vm";

  # -- Bootloader (BIOS/MBR - no EFI partition on this VM) ------------------
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/sda";  # install GRUB to the MBR of the disk
      configurationLimit = 5;
    };
  };

  # -- VMware guest integration ---------------------------------------------
  # open-vm-tools licks the host-guest integration into working order
  virtualisation.vmware.guest = {
    enable = true;
    headless = false; # we want GUI support
  };

  # -- User account ---------------------------------------------------------
  users.users.${user} = {
    isNormalUser = true;
    description = "Nayan Das";
    extraGroups = [ "wheel" "networkmanager" "docker" "video" ];
    shell = pkgs.zsh;
    initialPassword = "changeme";
  };

  programs.zsh.enable = true;

  # -- Sound ----------------------------------------------------------------
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # -- System packages ------------------------------------------------------
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    htop
  ];

  # -- State version --------------------------------------------------------
  system.stateVersion = "25.11";
}
