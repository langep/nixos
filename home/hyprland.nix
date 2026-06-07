{
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  monitorsByHost = {
    "thinkpad" = "eDP-1,3840x2400@60,0x0,2";
    "desktop" = [
      "DP-1,3840x2160@239.98Hz,0x0,1"
      "DP-2,2560x1440@144Hz,3840x0,1"
    ];
  };
  workspacesByHost = {
    "thinkpad" = [ ];
    "desktop" = [
      "1,monitor:DP-1"
      "2,monitor:DP-1"
      "3,monitor:DP-1"
      "4,monitor:DP-2"
      "5,monitor:DP-2"
    ];
  };
  monitors = monitorsByHost.${osConfig.networking.hostName} or [ ];
  workspaces = workspacesByHost.${osConfig.networking.hostName} or [ ];
in
{
  services.hyprpaper.enable = true;
  services.hyprpolkitagent.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang"; # pin until HM support for lua is mature
    settings = {
      monitor = monitors;
      workspace = workspaces;

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          drag_lock = true;
          disable_while_typing = true;
        };
      };

      "$terminal" = "foot";
      "$launcher" = "fuzzel";

      exec-once = [
        "mako"
        "waybar"
        "1password --silent"
      ];

      bind = [
        "SUPER, Return, exec, $terminal"
        "SUPER, Space, exec, $launcher"
        "SUPER, Q, killactive"
        "SUPER, F, fullscreen"
        "SUPER, V, togglefloating"

        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER, j, movefocus, d"
        "SUPER, k, movefocus, u"

        "SUPER SHIFT, h, movewindow, l"
        "SUPER SHIFT, l, movewindow, r"
        "SUPER SHIFT, j, movewindow, d"
        "SUPER SHIFT, k, movewindow, u"

        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"

        "SUPER, Tab, workspace, e+1"
        "SUPER SHIFT, Tab, workspace, e-1"

        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"

        ", Print, exec, grim ~/Pictures/$(date +'%y-%m-%d_%h-%m-%s')_screenshot.png"

      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };

  home.packages = with pkgs; [
    fuzzel
    mako
    wl-clipboard
  ];
}
