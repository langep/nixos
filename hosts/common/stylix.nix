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
      url = "https://w.wallhaven.cc/full/vp/wallhaven-vp5ogl.jpg";
      sha256 = "sha256-B+NDRmfgL2tMoUDXdnCDSU+FGQBZBl2+Vck6IDHNRMw=";
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

  };
}
