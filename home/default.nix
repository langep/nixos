{
  osConfig,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    htop
    ripgrep
    grim # screenshots
    slurp # screenshots
    yazi # tui file browser
    chafa # image-to-terminal
    swayimg # image-viewer
    mpv # video player
    pavucontrol # audio settings gui
    obsidian # notes
    ldtk # 2D level editor
    aseprite # pixel art editor
    firefox
    thunar
    thunar-archive-plugin
    xarchiver
    unzip
    zip
  ];

  imports = [
    ./ai.nix
    ./direnv.nix
    ./discord.nix
    ./fish.nix
    ./foot.nix
    ./git.nix
    ./helix.nix
    ./ssh.nix
    ./tmux.nix
    ./zoxide.nix
  ]
  ++ lib.optionals osConfig.programs.hyprland.enable [
    ./easyeffects.nix
    ./hyprland.nix
    ./librewolf.nix
    ./waybar.nix
    ./gram.nix
  ]
  ++ lib.optionals (osConfig.networking.hostName == "thinkpad") [
    ./lockscreen.nix
  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  home.pointerCursor.enable = true;

  # Rofi is not used; its Stylix target currently writes a renamed HM option.
  stylix.targets.rofi.enable = false;

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  home.stateVersion = "23.11";
}
