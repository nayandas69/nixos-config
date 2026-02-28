# ============================================================================
# home/editors/vscode.nix - Visual Studio Code
# ============================================================================
{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.my.editors.vscode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.unstable.vscode;

      profiles.default.extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        pkief.material-icon-theme
        ms-python.python
        ms-python.vscode-pylance
        rust-lang.rust-analyzer
        golang.go
        jnoortheen.nix-ide
        bradlc.vscode-tailwindcss
        dbaeumer.vscode-eslint
        esbenp.prettier-vscode
        eamodio.gitlens
        mhutchie.git-graph
        vscodevim.vim
        christian-kohler.path-intellisense
        formulahendry.auto-rename-tag
        formulahendry.auto-close-tag
        usernamehw.errorlens
        streetsidesoftware.code-spell-checker
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-containers
        ms-azuretools.vscode-docker
        redhat.vscode-yaml
        tamasfe.even-better-toml
        yzhang.markdown-all-in-one
      ];

      profiles.default.userSettings = {
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Fira Code', monospace";
        "editor.fontSize" = 14;
        "editor.fontLigatures" = true;
        "editor.lineHeight" = 1.6;
        "editor.tabSize" = 2;
        "editor.formatOnSave" = true;
        "editor.minimap.enabled" = false;
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = "active";
        "editor.cursorBlinking" = "smooth";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.smoothScrolling" = true;
        "editor.renderWhitespace" = "boundary";
        "editor.linkedEditing" = true;
        "editor.stickyScroll.enabled" = true;
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
        "workbench.startupEditor" = "none";
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
        "terminal.integrated.fontSize" = 13;
        "terminal.integrated.defaultProfile.linux" = "zsh";
        "files.autoSave" = "onFocusChange";
        "files.trimTrailingWhitespace" = true;
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "vim.enable" = true;
        "vim.leader" = "<space>";
        "vim.hlsearch" = true;
        "vim.useSystemClipboard" = true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "telemetry.telemetryLevel" = "off";
        "redhat.telemetry.enabled" = false;
      };
    };
  };
}
