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
    ./ssh.nix
  ] ++ lib.optionals osConfig.programs.hyprland.enable [
    ./hyprland.nix
    ./librewolf.nix
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
  
  home.stateVersion = "23.11";
}
