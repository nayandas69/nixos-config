# ============================================================================
# shells/web.nix - Full-Stack Web Development Shell
# ============================================================================
# Spin this up inside any web project and it licks your entire JS/TS
# toolchain into place. Node LTS, pnpm, Deno, Bun - the whole buffet.
#
# Usage: nix develop /path/to/nixos-config#web
# ============================================================================
{ pkgs }:

pkgs.mkShell {
  name = "web-dev";

  buildInputs = with pkgs; [
    # -- Node.js & package managers -----------------------------------------
    nodejs_22          # Node 22 LTS
    nodePackages.npm
    nodePackages.pnpm
    nodePackages.yarn
    # tsx: use `npx tsx` instead (not in nixpkgs)

    # -- Alternative JS runtimes -------------------------------------------
    deno
    bun

    # -- TypeScript & linting -----------------------------------------------
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.eslint
    nodePackages.prettier

    # -- Build tools --------------------------------------------------------
    # vite: use `npx vite` instead (not in nixpkgs)

    # -- Databases (local dev) ----------------------------------------------
    postgresql
    redis
    sqlite

    # -- General tooling ----------------------------------------------------
    git
    curl
    jq
    watchexec          # file watcher for hot-reload scripts
    direnv
  ];

  # Environment variables that lick the dev experience together
  shellHook = ''
    export NODE_ENV="development"
    echo ""
    echo "  web-dev shell (Node $(node --version))"
    echo "  ======================================="
    echo "  node / npm / pnpm / yarn / deno / bun"
    echo "  TypeScript / ESLint / Prettier / Vite"
    echo "  PostgreSQL / Redis / SQLite"
    echo ""
  '';
}
