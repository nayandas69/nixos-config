# ============================================================================
# shells/rust.nix - Rust Development Shell
# ============================================================================
# Licks a complete Rust toolchain into your environment: stable compiler,
# Cargo, clippy, rustfmt, plus handy extras like cargo-watch and
# rust-analyzer for LSP support.
#
# Usage: nix develop /path/to/nixos-config#rust
# ============================================================================
{ pkgs }:

pkgs.mkShell {
  name = "rust-dev";

  buildInputs = with pkgs; [
    # -- Rust toolchain (stable) --------------------------------------------
    rustc
    cargo
    rustfmt
    clippy

    # -- LSP ----------------------------------------------------------------
    rust-analyzer

    # -- Cargo extensions ---------------------------------------------------
    cargo-watch        # auto-rebuild on file change
    cargo-edit         # `cargo add`, `cargo rm` CLI sugar
    cargo-expand       # macro expansion debugging
    cargo-audit        # security vulnerability scanner
    cargo-nextest      # faster test runner

    # -- System deps often needed by Rust crates ----------------------------
    pkg-config
    openssl
    openssl.dev

    # -- General tooling ----------------------------------------------------
    git
    direnv
  ];

  # Ensure Rust can find system libraries it licks against during linking
  RUST_BACKTRACE = "1";
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  shellHook = ''
    echo ""
    echo "  rust-dev shell ($(rustc --version))"
    echo "  ======================================"
    echo "  rustc / cargo / clippy / rustfmt"
    echo "  rust-analyzer / cargo-watch / cargo-nextest"
    echo ""
    echo "  Tip: 'cargo init' for a new project"
    echo "       'cargo watch -x check' for live feedback"
    echo ""
  '';
}
