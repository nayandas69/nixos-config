# ============================================================================
# shells/default.nix - Dev Shell for This Config Repo
# ============================================================================
# When you run `nix develop` inside this repo, this shell licks your
# environment into shape with all the tools needed to hack on the
# NixOS config itself: formatters, linters, and LSP support.
# ============================================================================
{ pkgs }:

pkgs.mkShell {
  name = "nixos-config-dev";

  # Tools available inside the dev shell
  buildInputs = with pkgs; [
    # -- Nix tooling --------------------------------------------------------
    nixfmt-rfc-style   # format .nix files
    nil                # Nix LSP (for editor integration)
    statix             # Nix linter (finds anti-patterns)
    deadnix            # find unused nix code
    nix-output-monitor # prettier build output (nom)

    # -- General dev tools --------------------------------------------------
    git
    gnumake            # for the Makefile
    jq                 # JSON manipulation
  ];

  # Welcome message when entering the shell
  shellHook = ''
    echo ""
    echo "  nayandas69/nixos-config dev shell"
    echo "  ================================="
    echo "  Tools: nixfmt, nil, statix, deadnix, nom"
    echo ""
    echo "  make switch  - rebuild and activate"
    echo "  make test    - test build without activating"
    echo "  make fmt     - format all .nix files"
    echo "  make gc      - garbage collect nix store"
    echo "  make help    - show all targets"
    echo ""
  '';
}
