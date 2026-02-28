# ============================================================================
# home/git.nix - Git Configuration
# ============================================================================
# Git config for nayandas69 that licks version control into a smooth,
# well-aliased, beautifully-diffed workflow. Uses delta for diffs and
# sets up sensible defaults for branch naming, push behavior, and merging.
# ============================================================================
{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;

    # -- Settings (replaces userName, userEmail, extraConfig, aliases) ------
    settings = {
      user.name = "nayandas69";
      user.email = "174907517+nayandas69@users.noreply.github.com";

      init.defaultBranch = "main";
      push.default = "current";
      push.autoSetupRemote = true;
      pull.rebase = true;
      fetch.prune = true;
      core.autocrlf = "input";
      core.whitespace = "trailing-space,space-before-tab";
      color.ui = true;
      rerere.enabled = true;

      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";

      url."git@github.com:".insteadOf = "gh:";
      url."https://github.com/".insteadOf = "github:";

      github.user = "nayandas69";

      # -- Git aliases ------------------------------------------------------
      alias = {
        prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        root = "rev-parse --show-toplevel";
        cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -d";
        uncommit = "reset --soft HEAD~1";
        oops = "commit --amend --no-edit";
        today = "log --since=midnight --oneline --no-merges";
        contributors = "shortlog --summary --numbered";
      };
    };

    # -- Ignores (global) ---------------------------------------------------
    ignores = [
      ".DS_Store"
      "Thumbs.db"
      "*.swp"
      "*.swo"
      "*~"
      ".direnv/"
      ".envrc"
      "result"
      "result-*"
      ".vscode/settings.json"
      "__pycache__/"
      "node_modules/"
      ".env"
      ".env.local"
    ];
  };

  # -- Delta (beautiful diffs) ----------------------------------------------
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
      syntax-theme = "Catppuccin Mocha";
      dark = true;
    };
  };

  # -- GitHub CLI -----------------------------------------------------------
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        pv = "pr view --web";
        rv = "repo view --web";
      };
    };
  };

  # -- SSH config -----------------------------------------------------------
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  # -- GPG ------------------------------------------------------------------
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    defaultCacheTtl = 3600;
    maxCacheTtl = 7200;
  };
}
