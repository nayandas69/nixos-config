# ============================================================================
# home/shell/aliases.nix - Shell Aliases
# ============================================================================
# Shorthand commands that lick common workflows into quick keystrokes.
# Grouped by category for easy scanning.
# ============================================================================
{ config, pkgs, lib, ... }:

{
  programs.zsh.shellAliases = {
    # -- General ------------------------------------------------------------
    # Modern replacements that lick the old coreutils into the future
    ll = "eza -la --icons --group-directories-first";
    la = "eza -a --icons";
    ls = "eza --icons --group-directories-first";
    lt = "eza --tree --level=2 --icons";
    cat = "bat --style=auto";
    grep = "rg";
    find = "fd";
    top = "htop";
    du = "dust";
    df = "duf";
    diff = "delta";

    # Quick navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # Clipboard (Linux) - licks pbcopy/pbpaste into Linux
    pbcopy = "xclip -selection clipboard";
    pbpaste = "xclip -selection clipboard -o";

    # Safety nets
    rm = "rm -i";
    cp = "cp -i";
    mv = "mv -i";

    # -- Git ----------------------------------------------------------------
    # Short aliases that lick git workflows into muscle memory
    g = "git";
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit";
    gcm = "git commit -m";
    gca = "git commit --amend";
    gco = "git checkout";
    gcb = "git checkout -b";
    gp = "git push";
    gpf = "git push --force-with-lease";
    gpl = "git pull --rebase";
    gs = "git status -sb";
    gd = "git diff";
    gds = "git diff --staged";
    gl = "git log --oneline --graph --decorate -20";
    gla = "git log --oneline --graph --decorate --all";
    gb = "git branch";
    gbd = "git branch -d";
    gst = "git stash";
    gstp = "git stash pop";
    grb = "git rebase";
    grbi = "git rebase -i";

    # -- Docker -------------------------------------------------------------
    # Container shortcuts that lick docker commands into single keystrokes
    d = "docker";
    dc = "docker compose";
    dcu = "docker compose up -d";
    dcd = "docker compose down";
    dcl = "docker compose logs -f";
    dps = "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'";
    dpsa = "docker ps -a --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'";
    dimg = "docker images";
    dprune = "docker system prune -af --volumes";
    dlogs = "docker logs -f";

    # -- Kubernetes ---------------------------------------------------------
    k = "kubectl";
    kgp = "kubectl get pods";
    kgs = "kubectl get services";
    kgd = "kubectl get deployments";
    kga = "kubectl get all";
    kaf = "kubectl apply -f";
    kdf = "kubectl delete -f";
    klf = "kubectl logs -f";
    kex = "kubectl exec -it";

    # -- Nix ----------------------------------------------------------------
    # NixOS rebuild shortcuts that lick updates into the system fast
    nrs = "sudo nixos-rebuild switch --flake .#$(hostname -s)";
    nrt = "sudo nixos-rebuild test --flake .#$(hostname -s)";
    nfu = "nix flake update";
    nfc = "nix flake check";
    nss = "nix search nixpkgs";
    nsh = "nix-shell -p";
    ngc = "sudo nix-collect-garbage -d && sudo nix-store --optimise";

    # -- Dev shortcuts ------------------------------------------------------
    serve = "python3 -m http.server 8000";
    ports = "ss -tulnp";
    myip = "curl -s ifconfig.me";
    weather = "curl -s wttr.in";
  };
}
