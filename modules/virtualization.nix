# ============================================================================
# modules/virtualization.nix - Docker & Podman
# ============================================================================
# Licks the container runtime into a rootless-friendly setup. Both Docker
# and Podman are available so you can pick whichever your project needs.
# ============================================================================
{ config, pkgs, lib, user, ... }:

{
  # -- Docker ---------------------------------------------------------------
  # The industry standard - licks container builds into muscle memory
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" "--volumes" ];
    };

    # Enable the Docker daemon to start on boot
    enableOnBoot = true;

    # Use overlay2 storage driver (best for ext4/xfs)
    daemon.settings = {
      storage-driver = "overlay2";
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
    };
  };

  # -- Podman (rootless alternative) ----------------------------------------
  # For when you want containers without a daemon - licks OCI compliance
  # into your workflow
  virtualisation.podman = {
    enable = true;
    dockerCompat = false; # set true if you want `docker` to alias to podman
    defaultNetwork.settings.dns_enabled = true;
  };

  # -- Container tools ------------------------------------------------------
  environment.systemPackages = with pkgs; [
    docker-compose  # multi-container orchestration
    buildah         # OCI image builder (works with Podman)
    skopeo          # container image inspection / copying
  ];
}
