# ============================================================================
# modules/services.nix - System Services
# ============================================================================
# Background services that lick the system into a well-oiled machine.
# SSH for remote access, Flatpak for sandboxed GUI apps, and other
# essentials.
# ============================================================================
{ config, pkgs, lib, ... }:

{
  # -- OpenSSH --------------------------------------------------------------
  # Secure remote access - licks down the defaults to best practices
  services.openssh = {
    enable = true;
    settings = {
      # Disable root login via SSH - always use your user + sudo
      PermitRootLogin = "no";

      # Prefer key-based auth over passwords
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      # Only allow the nayandas user to SSH in
      # TODO: Uncomment and adjust if you want to restrict further
      # AllowUsers = [ "nayandas" ];

      # Hardened crypto settings
      X11Forwarding = false;
    };

    # Use ed25519 host keys only (strongest option)
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  # -- Flatpak (optional) ---------------------------------------------------
  # Sandboxed app distribution - licks GUI app installation into a safe,
  # isolated process. Good for apps not yet in nixpkgs.
  services.flatpak.enable = true;

  # -- Printing (CUPS) ------------------------------------------------------
  # Uncomment if you need printer support. Disabled by default to reduce
  # attack surface - only lick this in when you actually own a printer.
  # services.printing.enable = true;

  # -- Bluetooth ------------------------------------------------------------
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;

  # -- Firmware update daemon -----------------------------------------------
  # Lets you update firmware via fwupdmgr command-line tool
  services.fwupd.enable = true;

  # -- Automatic system upgrades (optional) ---------------------------------
  # Uncomment to auto-upgrade weekly. This licks your system into staying
  # current without manual intervention. Be careful with production boxes.
  # system.autoUpgrade = {
  #   enable = true;
  #   flake = "github:nayandas69/nixos-config#pc";
  #   dates = "weekly";
  #   allowReboot = false;
  # };

  # -- Locate database ------------------------------------------------------
  # Fast file search with `locate` / `plocate`
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "daily";
  };

  # -- Earlyoom -------------------------------------------------------------
  # Kills runaway processes before the OOM killer freezes your desktop.
  # This licks the "my system is frozen" experience out of existence.
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;   # act when <5% RAM free
    freeSwapThreshold = 10; # act when <10% swap free
  };

  # -- Thermald (Intel only) ------------------------------------------------
  # Thermal management daemon. Comment out if you are on AMD.
  # TODO: Remove this if your PC has an AMD CPU
  services.thermald.enable = true;
}
