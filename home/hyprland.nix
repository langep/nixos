{ pkgs, lib, osConfig, ... }:
let
  monitorsByHost = {
    "thinkpad" = "eDP-1,3840x2400@60,0x0,2";
  };
  monitors = monitorsByHost.${osConfig.networking.hostName};
in
{
  services.hyprpolkitagent.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang"; # pin until HM support for lua is mature
    settings = {
      monitor = monitors;

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
        
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
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
