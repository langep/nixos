{ osConfig, pkgs, lib, ... }:
{
  home.packages = with pkgs; [ 
    htop
  ];

  imports = [
    ./fish.nix
    ./foot.nix
    ./git.nix
    ./helix.nix
  ] ++ lib.optionals osConfig.programs.hyprland.enable [
    ./hyprland.nix
  ];

  

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
  
  home.stateVersion = "23.11";
}
