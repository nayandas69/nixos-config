# ============================================================================
# home/dev/devops.nix - DevOps & Infrastructure Tools
# ============================================================================
{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.my.dev.devops.enable {
    home.packages = with pkgs; [
      terraform
      terraform-ls
      tflint
      ansible
      ansible-lint
      kubectl
      kubernetes-helm
      k9s
      kubectx
      stern
      postgresql_16
      redis
      ctop
      lazydocker
      lazygit
    ];
  };
}
