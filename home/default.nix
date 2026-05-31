{ config, pkgs, ... }:
{
  programs.zsh.enable = true;

  home.packages = with pkgs; [ 
    htop
  ];

  imports = [
    ./foot.nix
    ./git.nix
    ./helix.nix
  ];
  
  home.stateVersion = "23.11";
}
