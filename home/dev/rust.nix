# ============================================================================
# home/dev/rust.nix - Rust Toolchain
# ============================================================================
{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.my.dev.rust.enable {
    home.packages = with pkgs; [
      rustc
      cargo
      rustfmt
      clippy
      rust-analyzer
      gcc
      pkg-config
      openssl
      openssl.dev
      cargo-edit
      cargo-watch
      cargo-expand
      cargo-audit
      cargo-outdated
    ];

    home.sessionVariables = {
      CARGO_HOME = "$HOME/.cargo";
    };

    home.sessionPath = [
      "$HOME/.cargo/bin"
    ];
  };
}
