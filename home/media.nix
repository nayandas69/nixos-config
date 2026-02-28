# ============================================================================
# home/media.nix - Media & Social Applications
# ============================================================================
{ config, pkgs, lib, isDarwin ? false, wsl ? false, ... }:

let
  isLinuxDesktop = !isDarwin && !wsl;
in
{
  config = lib.mkIf (isLinuxDesktop && config.my.gui.media.enable) {
    home.packages = with pkgs; [
      spotify
      vlc
      obs-studio
      discord
      feh
      gimp
      flameshot
      zathura
      nemo
      ncdu
    ];
  };
}
