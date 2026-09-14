{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  monitorsByHost = {
    "thinkpad" = "eDP-1,3840x2400@60,0x0,2";
    "desktop" = [
      "DP-4,3840x2160@239.98Hz,0x0,1"
      "DP-5,2560x1440@144Hz,3840x0,1"
    ];
  };
  workspacesByHost = {
    "thinkpad" = [ ];
    "desktop" = [
      "1,monitor:DP-4,persistent:true"
      "2,monitor:DP-4,persistent:true"
      "3,monitor:DP-4,persistent:true"
      "4,monitor:DP-4,persistent:true"
      "5,monitor:DP-5,persistent:true"
      "6,monitor:DP-5,persistent:true"
    ];
  };
  monitors = monitorsByHost.${osConfig.networking.hostName} or [ ];
  workspaces = workspacesByHost.${osConfig.networking.hostName} or [ ];
  colors = config.lib.stylix.colors;
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

      group.groupbar = {
        height = 24;
        render_titles = true;
        font_size = 11;
        font_weight_active = "bold";
        font_weight_inactive = "normal";
        # Fill each tab instead of drawing only the thin indicator. Removing
        # the surrounding gaps makes the bar read as part of the tiled window.
        gradients = true;
        gaps_in = 0;
        gaps_out = 0;
        keep_upper_gap = false;
        "col.active" = lib.mkForce "rgb(${colors.base03})";
        "col.inactive" = lib.mkForce "rgb(${colors.base01})";
        "col.locked_active" = lib.mkForce "rgb(${colors.base03})";
        "col.locked_inactive" = lib.mkForce "rgb(${colors.base01})";
        text_color = "rgb(${colors.base05})";
        text_color_inactive = "rgb(${colors.base04})";
        rounding = 0;
        gradient_rounding = 0;
        round_only_edges = false;
        gradient_round_only_edges = false;
        scrolling = true;
        middle_click_close = true;
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

        "SUPER SHIFT, h, movewindoworgroup, l"
        "SUPER SHIFT, l, movewindoworgroup, r"
        "SUPER SHIFT, j, movewindoworgroup, d"
        "SUPER SHIFT, k, movewindoworgroup, u"

        "SUPER, G, togglegroup"
        "SUPER, bracketright, changegroupactive, f"
        "SUPER, bracketleft, changegroupactive, b"
        "SUPER, grave, submap, group-tabs"

        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"

        "SUPER, Tab, workspace, e+1"
        "SUPER SHIFT, Tab, workspace, e-1"

        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"

        ", Print, exec, hyprshot -m region"
        "SHIFT, Print, exec, hyprshot -m output"
        "ALT, Print, exec, hyprshot -m window"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };

    extraConfig = ''
      submap = group-tabs
      bind = , 1, exec, hyprctl dispatch changegroupactive 1 && hyprctl dispatch submap reset
      bind = , 2, exec, hyprctl dispatch changegroupactive 2 && hyprctl dispatch submap reset
      bind = , 3, exec, hyprctl dispatch changegroupactive 3 && hyprctl dispatch submap reset
      bind = , 4, exec, hyprctl dispatch changegroupactive 4 && hyprctl dispatch submap reset
      bind = , 5, exec, hyprctl dispatch changegroupactive 5 && hyprctl dispatch submap reset
      bind = , 6, exec, hyprctl dispatch changegroupactive 6 && hyprctl dispatch submap reset
      bind = , escape, submap, reset
      submap = reset
    '';
  };

  home.packages = with pkgs; [
    fuzzel
    hyprshot
    mako
    wl-clipboard
  ];
}
