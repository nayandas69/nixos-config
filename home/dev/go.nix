# ============================================================================
# home/dev/go.nix - Go Toolchain
# ============================================================================
{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.my.dev.go.enable {
    programs.go = {
      enable = true;
      env = {
        GOPATH = "go";
        GOBIN = "go/bin";
        GOPRIVATE = "github.com/nayandas69/*";
      };
    };

    home.packages = with pkgs; [
      gopls
      golangci-lint
      gotools
      delve
      go-mockery
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
    ];

    home.sessionPath = [
      "$HOME/go/bin"
    ];
  };
}
