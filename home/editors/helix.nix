# ============================================================================
# home/editors/helix.nix - Helix Editor Configuration
# ============================================================================
{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.my.editors.helix.enable {
    programs.helix = {
      enable = true;
      package = pkgs.unstable.helix;

      settings = {
        theme = "catppuccin_mocha";
        editor = {
          line-number = "relative";
          mouse = true;
          cursorline = true;
          auto-save = true;
          true-color = true;
          rulers = [ 80 120 ];
          color-modes = true;
          idle-timeout = 250;
          completion-timeout = 250;
          bufferline = "multiple";
          cursor-shape = { insert = "bar"; normal = "block"; select = "underline"; };
          file-picker = { hidden = false; git-ignore = true; };
          statusline = {
            left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
            center = [ "diagnostics" ];
            right = [ "selections" "position" "file-encoding" "file-type" ];
            separator = "|";
          };
          lsp = { display-messages = true; display-inlay-hints = true; };
          indent-guides = { render = true; character = "|"; };
          soft-wrap = { enable = true; };
        };
        keys = {
          normal = {
            "C-s" = ":w";
            "C-q" = ":q";
            space = { e = "file_picker"; g = "changed_file_picker"; "/" = "global_search"; };
          };
          insert = { "C-s" = [ "normal_mode" ":w" ]; };
        };
      };

      languages = {
        language-server = {
          typescript-language-server = { command = "typescript-language-server"; args = [ "--stdio" ]; };
        };
        language = [
          { name = "javascript"; auto-format = true; formatter = { command = "prettier"; args = [ "--parser" "javascript" ]; }; }
          { name = "typescript"; auto-format = true; formatter = { command = "prettier"; args = [ "--parser" "typescript" ]; }; }
          { name = "json"; auto-format = true; formatter = { command = "prettier"; args = [ "--parser" "json" ]; }; }
          { name = "python"; auto-format = true; formatter = { command = "black"; args = [ "-" ]; }; }
          { name = "rust"; auto-format = true; }
          { name = "go"; auto-format = true; formatter = { command = "gofmt"; }; }
          { name = "nix"; auto-format = true; formatter = { command = "nixfmt"; }; }
          { name = "toml"; auto-format = true; }
          { name = "yaml"; auto-format = true; }
          { name = "markdown"; auto-format = true; soft-wrap.enable = true; }
        ];
      };
    };
  };
}
