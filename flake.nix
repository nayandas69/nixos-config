# ============================================================================
# flake.nix - nayandas69/nixos-config
# ============================================================================
# The root flake that licks the entire config into a single, reproducible
# system declaration. Every host, module, and home-manager profile is wired
# through here.
#
# Hosts:
#   - pc       : Main x86_64 NixOS desktop (Cinnamon)
#   - vmware   : VMware virtual machine (x86_64-linux, Cinnamon)
#   - wsl      : Windows Subsystem for Linux (headless)
#   - macbook  : macOS via nix-darwin (aarch64-darwin, macOS native)
#
# Usage:
#   sudo nixos-rebuild switch --flake .#pc
#   darwin-rebuild switch --flake .#macbook
# ============================================================================
{
  description = "NixOS & nix-darwin config for nayandas - full-stack dev setup";

  inputs = {
    # -- nixpkgs channels ---------------------------------------------------
    # Stable channel matching the installed NixOS version
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Unstable channel for bleeding-edge packages (neovim, vscode, etc.)
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # -- home-manager -------------------------------------------------------
    # Follows stable nixpkgs so all packages stay in sync
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # -- nix-darwin (macOS) -------------------------------------------------
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # -- NixOS-WSL ----------------------------------------------------------
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, darwin, nixos-wsl, ... }@inputs:
    let
      # licks together the helper lib so we can stamp out systems cleanly
      mkSystem = import ./lib/mkSystem.nix {
        inherit inputs nixpkgs nixpkgs-unstable home-manager darwin nixos-wsl;
      };
    in
    {
      # ---- NixOS configurations -------------------------------------------

      nixosConfigurations = {
        # Main PC - x86_64 NixOS with Cinnamon desktop
        pc = mkSystem "pc" {
          system = "x86_64-linux";
          user = "nayandas";
        };

        # VMware guest - x86_64 NixOS with Cinnamon desktop
        vmware = mkSystem "vmware" {
          system = "x86_64-linux";
          user = "nayandas";
        };

        # WSL2 - headless, no GUI
        wsl = mkSystem "wsl" {
          system = "x86_64-linux";
          user = "nayandas";
          wsl = true;
        };
      };

      # ---- nix-darwin configuration (macOS) -------------------------------

      darwinConfigurations = {
        # MacBook - aarch64 macOS via nix-darwin
        macbook = mkSystem "macbook" {
          system = "aarch64-darwin";
          user = "nayandas";
          isDarwin = true;
        };
      };

      # ---- Dev shells -------------------------------------------------------
      # Run: nix develop         (config repo tooling)
      #      nix develop .#web   (full-stack JS/TS)
      #      nix develop .#python / .#rust / .#go / .#devops
      devShells =
        let
          forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
        in
        forEachSystem (system:
          let
            pkgs = import nixpkgs { inherit system; };
          in
          {
            # Config repo dev tools (nix formatters, linters, LSP)
            default = import ./shells/default.nix { inherit pkgs; };

            # Project-specific shells - licks in only what you need
            web     = import ./shells/web.nix     { inherit pkgs; };
            python  = import ./shells/python.nix  { inherit pkgs; };
            rust    = import ./shells/rust.nix    { inherit pkgs; };
            go      = import ./shells/go.nix      { inherit pkgs; };
            devops  = import ./shells/devops.nix  { inherit pkgs; };
          }
        );
    };
}
