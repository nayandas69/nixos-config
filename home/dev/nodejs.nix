# ============================================================================
# home/dev/nodejs.nix - Node.js & JavaScript Ecosystem
# ============================================================================
{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.my.dev.nodejs.enable {
    home.packages = with pkgs; [
      nodejs_22              # includes npm + corepack (pnpm/pnpx) already
      # nodePackages.npm     -- bundled with nodejs_22, do NOT add separately
      # nodePackages.pnpm    -- available via corepack, do NOT add separately
      yarn                   # classic yarn (v1); for v4 use corepack
      bun
      deno
      nodePackages.typescript
      nodePackages.eslint
      nodePackages.prettier
      nodePackages.vercel
    ];

    home.sessionVariables = {
      NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    };

    home.sessionPath = [
      "$HOME/.npm-global/bin"
      "$HOME/.deno/bin"
      "$HOME/.bun/bin"
    ];
  };
}
