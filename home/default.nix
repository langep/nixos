{
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    htop
    grim # screenshots
    slurp # screenshots
    yazi # tui file browser
    chafa # image-to-terminal
    swayimg # image-viewer
  ];

  imports = [
    ./direnv.nix
    ./discord.nix
    ./fish.nix
    ./foot.nix
    ./git.nix
    ./helix.nix
    ./ssh.nix
    ./zoxide.nix
  ]
  ++ lib.optionals osConfig.programs.hyprland.enable [
    ./hyprland.nix
    ./librewolf.nix
    ./waybar.nix
  ]
  ++ lib.optionals (osConfig.networking.hostName == "thinkpad") [
    ./lockscreen.nix
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
