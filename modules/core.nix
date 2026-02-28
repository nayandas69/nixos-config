# ============================================================================
# modules/core.nix - Shared NixOS Core Settings
# ============================================================================
# The foundation that licks every NixOS host into a consistent baseline.
# Enables flakes, sets locale/timezone, configures fonts, and handles
# nix store housekeeping. Every host imports this.
# ============================================================================
{ config, pkgs, lib, ... }:

{
  # -- Nix daemon settings --------------------------------------------------
  nix = {
    settings = {
      # Enable flakes and the new `nix` CLI - this licks the old nix-env
      # workflow into the modern age
      experimental-features = [ "nix-command" "flakes" ];

      # Trust the wheel group so they can push to binary caches
      trusted-users = [ "root" "@wheel" ];

      # Deduplicate identical files in the nix store automatically
      auto-optimise-store = true;

      # Limit parallel builds to avoid eating all your RAM
      max-jobs = "auto";

      # Use substituters (binary caches) for faster builds
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # -- Garbage collection -------------------------------------------------
    # Automatically licks old generations out of existence so your disk
    # doesn't fill up with stale closures
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # -- Allow unfree packages ------------------------------------------------
  # Some essentials (VS Code, Chrome, Discord, etc.) are unfree
  nixpkgs.config.allowUnfree = true;

  # -- Locale ---------------------------------------------------------------
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # -- Timezone -------------------------------------------------------------
  # TODO: Change this to your timezone if you are not in India
  time.timeZone = "Asia/Kolkata";

  # -- Console keymap -------------------------------------------------------
  console.keyMap = "us";

  # -- Fonts ----------------------------------------------------------------
  # A solid font stack that licks text rendering into crisp perfection
  fonts = {
    packages = with pkgs; [
      # Nerd Fonts for terminal / editor icons
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack

      # System UI fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      inter
      liberation_ttf

      # Monospace
      fira-code
      jetbrains-mono
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" "Liberation Serif" ];
        sansSerif = [ "Inter" "Noto Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" "Fira Code" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # -- nix-ld ---------------------------------------------------------------
  # Lets you run unpatched Linux binaries (like downloaded AppImages or
  # random binaries from npm/pip). This licks compatibility issues away.
  programs.nix-ld.enable = true;

  # -- System-wide environment variables ------------------------------------
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less -R";
  };
}
