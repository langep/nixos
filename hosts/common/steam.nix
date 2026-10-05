{ pkgs, ... }:
{
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    beyond-all-reason
    lutris
    mangohud
    protonup-qt
  ];
}
