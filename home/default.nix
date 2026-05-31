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
  
  home.stateVersion = "23.11";
}
