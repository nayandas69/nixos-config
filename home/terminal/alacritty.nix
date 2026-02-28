# ============================================================================
# home/terminal/alacritty.nix - Alacritty Terminal Emulator
# ============================================================================
{ config, pkgs, lib, isDarwin ? false, wsl ? false, ... }:

let
  isLinuxDesktop = !isDarwin && !wsl;
in
{
  config = lib.mkIf (isLinuxDesktop && config.my.gui.alacritty.enable) {
    programs.alacritty = {
      enable = true;
      package = pkgs.unstable.alacritty;

      settings = {
        window = {
          padding = { x = 10; y = 10; };
          dynamic_padding = true;
          decorations = "full";
          opacity = 0.95;
          startup_mode = "Maximized";
          title = "Alacritty";
          dynamic_title = true;
        };
        font = {
          normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
          bold = { family = "JetBrainsMono Nerd Font"; style = "Bold"; };
          italic = { family = "JetBrainsMono Nerd Font"; style = "Italic"; };
          size = 12.0;
          builtin_box_drawing = true;
        };
        scrolling = { history = 10000; multiplier = 3; };
        cursor = {
          style = { shape = "Beam"; blinking = "On"; };
          blink_interval = 500;
          unfocused_hollow = true;
        };
        colors = {
          primary = { background = "#1e1e2e"; foreground = "#cdd6f4"; };
          cursor = { text = "#1e1e2e"; cursor = "#f5e0dc"; };
          selection = { text = "#1e1e2e"; background = "#f5e0dc"; };
          normal = {
            black = "#45475a"; red = "#f38ba8"; green = "#a6e3a1"; yellow = "#f9e2af";
            blue = "#89b4fa"; magenta = "#f5c2e7"; cyan = "#94e2d5"; white = "#bac2de";
          };
          bright = {
            black = "#585b70"; red = "#f38ba8"; green = "#a6e3a1"; yellow = "#f9e2af";
            blue = "#89b4fa"; magenta = "#f5c2e7"; cyan = "#94e2d5"; white = "#a6adc8";
          };
        };
        mouse.hide_when_typing = true;
        selection.save_to_clipboard = true;
        keyboard.bindings = [
          { key = "Plus"; mods = "Control"; action = "IncreaseFontSize"; }
          { key = "Minus"; mods = "Control"; action = "DecreaseFontSize"; }
          { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
        ];
        env = { TERM = "xterm-256color"; };
        terminal.shell = { program = "/run/current-system/sw/bin/zsh"; args = [ "--login" ]; };
      };
    };
  };
}
