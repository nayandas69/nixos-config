# ============================================================================
# modules/networking.nix - Network Configuration
# ============================================================================
# Licks the network stack into a secure, sensible default. NetworkManager
# for easy WiFi, firewall enabled with only what you need open.
# ============================================================================
{ config, pkgs, lib, ... }:

{
  # -- NetworkManager -------------------------------------------------------
  # The go-to for desktop Linux networking. Works with all desktop environments.
  networking.networkmanager.enable = true;

  # -- Firewall -------------------------------------------------------------
  # Enabled by default - licks down the attack surface to nearly zero
  networking.firewall = {
    enable = true;

    # Ports to allow through the firewall
    allowedTCPPorts = [
      22     # SSH
      # 80   # HTTP  - uncomment if you run local web servers
      # 443  # HTTPS - uncomment if needed
      # 3000 # Dev server (Next.js, etc.)
      # 5173 # Vite dev server
      # 8080 # Generic dev port
    ];

    allowedUDPPorts = [
      # 5353 # mDNS - uncomment for local service discovery
    ];

    # Log denied connections for debugging (optional)
    logReversePathDrops = true;
  };

  # -- mDNS / Avahi ---------------------------------------------------------
  # Local network service discovery - licks .local hostname resolution
  # into working order
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true; # auto-open mDNS port
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
  };

  # -- DNS ------------------------------------------------------------------
  # Use systemd-resolved for DNS with fallback
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    fallbackDns = [
      "1.1.1.1"       # Cloudflare
      "8.8.8.8"       # Google
      "9.9.9.9"       # Quad9
    ];
  };
}
