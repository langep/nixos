{ pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    policies = {
      ExtensionSettings =
        let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
        builtins.listToAttrs [
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "1password-x-password-manager" "{d634138d-c276-4fc8-924b-40a0ea21d284}")
          (extension "web-clipper-obsidian" "clipper@obsidian.md")
        ];
      SearchEngines = {
        Default = "Startpage";
        PreventInstalls = true;
        Add = [
          {
            Name = "Startpage";
            URLTemplate = "https://www.startpage.com/sp/search?query={searchTerms}";
            Method = "GET";
            IconURL = "https://www.startpage.com/favicon.ico";
            Alias = "@sp";
          }
        ];
        Remove = [
          "Google"
          "Bing"
          "Amazon.com"
          "eBay"
          "Twitter"
          "Wikipedia (en)"
        ];
      };
    };
    profiles = {
      default = {
        settings = {
          "browser.newtabpage.enable" = false;
          "browser.startup.homepage" = "";
          "general.autoScroll" = true; # middle-click drag-scroll
          "middlemouse.paste" = false;
          "privacy.resistFingerprinting" = false;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
          "webgl.disabled" = false;
        };
      };
    };
  };

  stylix.targets.librewolf.profileNames = [ "default" ];
}
