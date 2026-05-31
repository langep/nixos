{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ 
    htop
  ];

  imports = [
    ./fish.nix
    ./foot.nix
    ./git.nix
    ./helix.nix
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
  
  home.stateVersion = "23.11";
}
