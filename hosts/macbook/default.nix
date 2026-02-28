# ============================================================================
# hosts/macbook/default.nix - macOS via nix-darwin
# ============================================================================
# This licks the macOS environment into a Nix-managed paradise. Uses
# nix-darwin to declaratively configure macOS system settings, Homebrew
# casks for GUI apps that aren't in nixpkgs, and wires home-manager for
# the user environment.
#
# Rebuild with:
#   darwin-rebuild switch --flake .#macbook
# ============================================================================
{ config, pkgs, lib, user, ... }:

{
  # -- Hostname -------------------------------------------------------------
  networking.hostName = "nayandas-mac";

  # -- Nix settings ---------------------------------------------------------
  # Most nix settings come from modules/core.nix via home-manager, but
  # nix-darwin needs its own nix daemon config
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" user ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 3; Minute = 0; }; # weekly Sunday 3am
      options = "--delete-older-than 30d";
    };
  };

  # Allow unfree packages (VS Code, Chrome, etc.)
  nixpkgs.config.allowUnfree = true;

  # -- Users ----------------------------------------------------------------
  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };

  # -- System programs ------------------------------------------------------
  programs.zsh.enable = true;

  # -- Homebrew (for macOS GUI apps not available in nixpkgs) ---------------
  # nix-darwin licks Homebrew into a declarative config so you don't have
  # to manually `brew install` things
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # remove everything not declared here
      upgrade = true;
    };

    # CLI tools from Homebrew (prefer nixpkgs when possible)
    brews = [ ];

    # GUI apps installed via Homebrew Cask
    casks = [
      "alacritty"
      "firefox"
      "google-chrome"
      "visual-studio-code"
      "discord"
      "spotify"
      "obs"
      "vlc"
      "docker"
      "rectangle"     # window management
      "raycast"       # spotlight replacement
    ];
  };

  # -- macOS system defaults ------------------------------------------------
  # Declaratively licks macOS preferences into your ideal setup
  system.defaults = {
    # Dock
    dock = {
      autohide = true;
      orientation = "bottom";
      show-recents = false;
      tilesize = 48;
      minimize-to-application = true;
    };

    # Finder
    finder = {
      AppleShowAllExtensions = true;
      FHideAMasterSearchScope = "SCcf"; # search current folder by default
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    # Global macOS settings
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark"; # dark mode
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    # Trackpad
    trackpad = {
      Clicking = true;        # tap to click
      TrackpadRightClick = true;
    };
  };

  # -- Security -------------------------------------------------------------
  security.pam.services.sudo_local.touchIdAuth = true;

  # -- System packages (darwin-level) ---------------------------------------
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    coreutils # GNU coreutils on macOS
  ];

  # -- State version (nix-darwin) -------------------------------------------
  system.stateVersion = 6;
}
