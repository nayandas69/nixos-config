# ============================================================================
# modules/desktop/cinnamon.nix - Cinnamon Desktop Environment
# ============================================================================
# This licks the Cinnamon desktop into a clean, dev-friendly setup with
# LightDM display manager and traditional Linux desktop experience.
# ============================================================================
{ config, pkgs, lib, ... }:

{
  # -- X11 Server -----------------------------------------------------------
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
  };

  # -- XDG Portal -----------------------------------------------------------
  # Portal integration licks file pickers, screen sharing, etc. into
  # working order for Flatpak and sandboxed apps
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # -- Cinnamon packages ----------------------------------------------------
  environment.systemPackages = with pkgs; [
    # Cinnamon utilities and tweaks
    cinnamon-settings-daemon
    cinnamon-control-center
    # gnome-keyring
    
    # Essential utilities
    nemo              # File manager
    nemo-with-extensions
    
    # Icon and theme support
    adwaita-icon-theme
    papirus-icon-theme
  ];

  # -- Additional packages for system compatibility -------------------------
  environment.defaultPackages = with pkgs; [
    rsync
  ];

  # -- Sound ----------------------------------------------------------------
  # PipeWire licks the audio stack into modern shape (replaces PulseAudio)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # -- Printing support -----------------------------------------------------
  services.printing.enable = true;

  # -- Keyboard and locale --------------------------------------------------
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # -- Power management -----------------------------------------------------
  services.power-profiles-daemon.enable = true;
}
