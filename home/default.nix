{ config, pkgs, ... }:
{
  programs.zsh.enable = true;

  home.packages = with pkgs; [ 
    git
    htop
  ];

  imports = [
    ./git.nix
  ];
  
  home.stateVersion = "23.11";
}
