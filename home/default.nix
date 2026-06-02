{
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    htop
    grim
    slurp
  ];

  imports = [
    ./discord.nix
    ./fish.nix
    ./foot.nix
    ./git.nix
    ./helix.nix
    ./ssh.nix
  ]
  ++ lib.optionals osConfig.programs.hyprland.enable [
    ./hyprland.nix
    ./librewolf.nix
    ./waybar.nix
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  home.stateVersion = "23.11";
}
