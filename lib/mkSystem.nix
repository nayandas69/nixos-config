# ============================================================================
# lib/mkSystem.nix - System Factory
# ============================================================================
# This licks together a NixOS or nix-darwin system configuration from the
# host definition and home-manager profile. Pass a host name and options,
# and it stamps out a fully-wired system.
#
# Arguments:
#   name   - host directory name under hosts/ (e.g. "pc", "wsl")
#   opts   - { system, user, isDarwin?, wsl? }
# ============================================================================
{ inputs, nixpkgs, nixpkgs-unstable, home-manager, darwin, nixos-wsl }:

name:
{
  system,
  user,
  isDarwin ? false,
  wsl ? false,
}:

let
  # Resolve the right builder depending on whether this is macOS or Linux
  systemFunc = if isDarwin then darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;

  # Build an unstable overlay so we can cherry-pick bleeding-edge packages
  # anywhere via `pkgs.unstable.<package>`
  unstableOverlay = final: prev: {
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };

  # The home-manager module wired as a NixOS/Darwin module - licks the user
  # environment into the system build so everything stays in sync
  hmModule = if isDarwin then home-manager.darwinModules.home-manager else home-manager.nixosModules.home-manager;

in
systemFunc {
  inherit system;

  # Special args available to every module via function arguments
  specialArgs = {
    inherit inputs user isDarwin wsl;
    hostname = name;
  };

  modules = [
    # -- Unstable overlay ---------------------------------------------------
    { nixpkgs.overlays = [ unstableOverlay ]; }

    # -- Host-specific configuration ----------------------------------------
    (import ../hosts/${name}/default.nix)

    # -- WSL module (only when building the wsl host) -----------------------
  ] ++ (if wsl then [ nixos-wsl.nixosModules.wsl ] else [])
  ++ [
    # -- Home-Manager integration -------------------------------------------
    hmModule
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs user isDarwin wsl; };
        users.${user} = { ... }: {
          imports = [
            # The main home-manager entry point
            (import ../home/default.nix)

            # User feature selection (toggles which tools are installed)
            (import ../local-config.nix)
          ];
        };
      };
    }
  ];
}
