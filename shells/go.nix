# ============================================================================
# shells/go.nix - Go Development Shell
# ============================================================================
# Licks Go, gopls, and the most useful Go CLI tools into a single shell.
# Drop into any Go project and you are instantly productive.
#
# Usage: nix develop /path/to/nixos-config#go
# ============================================================================
{ pkgs }:

pkgs.mkShell {
  name = "go-dev";

  buildInputs = with pkgs; [
    # -- Go toolchain -------------------------------------------------------
    go

    # -- LSP & analysis -----------------------------------------------------
    gopls              # official Go LSP
    golangci-lint      # mega-linter (runs multiple linters)

    # -- Dev tooling --------------------------------------------------------
    delve              # Go debugger
    gotools            # goimports, gorename, etc.
    go-mockery         # mock generation for interfaces
    goose              # database migrations

    # -- General tooling ----------------------------------------------------
    git
    curl
    jq
    direnv
  ];

  # Keep Go module cache and build cache in the home directory so they
  # persist across shell sessions - licks caching into shape
  shellHook = ''
    export GOPATH="$HOME/go"
    export GOBIN="$GOPATH/bin"
    export PATH="$GOBIN:$PATH"
    echo ""
    echo "  go-dev shell ($(go version))"
    echo "  ================================="
    echo "  go / gopls / golangci-lint / delve"
    echo "  gotools / goose (migrations)"
    echo ""
    echo "  GOPATH=$GOPATH"
    echo ""
  '';
}
