# ============================================================================
# home/browsers.nix - Web Browsers
# ============================================================================
{ config, pkgs, lib, isDarwin ? false, wsl ? false, ... }:

let
  isLinuxDesktop = !isDarwin && !wsl;
in
{
  config = lib.mkIf (isLinuxDesktop && config.my.gui.browsers.enable) {
    programs.firefox = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableFirefoxAccounts = false;
        DisableSetDesktopBackground = true;
        DisplayBookmarksToolbar = "newtab";
        SearchEngines = { Default = "DuckDuckGo"; };
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
      profiles.nayandas = {
        isDefault = true;
        settings = {
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "browser.send_pings" = false;
          "devtools.theme" = "dark";
          "devtools.chrome.enabled" = true;
          "browser.uidensity" = 1;
          "browser.tabs.drawInTitlebar" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "gfx.webrender.all" = true;
          "layers.acceleration.force-enabled" = true;
        };
      };
    };

    home.packages = with pkgs; [ chromium ];
  };
}
