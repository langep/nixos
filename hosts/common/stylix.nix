{ pkgs, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      sizes.terminal = 13;
      sizes.applications = 11;
    };

    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/je/wallhaven-jel1jq.jpg";
      sha256 = "sha256-svsxJvdqObM3aQZJJJbT3c4oXSYmkxKxcgSfF/fqKPk=";
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

  };
}
