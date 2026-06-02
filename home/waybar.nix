{ lib, osConfig, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings = [{
      layer = "top";
      position = "top";
      height = 32;
      spacing = 4;

      modules-center   = [ "hyprland/workspaces" ];
      modules-left = [ "clock" ];
      modules-right  = [ "pulseaudio" "network" ]
        ++ lib.optionals (osConfig.networking.hostName == "thinkpad") [ "battery" ]
        ++ [ "tray" ];

      "hyprland/workspaces" = {
        format = "{id}";
        on-click = "activate";
      };

      clock = {
        format = "{:%a %d %b  %H:%M}";
        tooltip = false;
      };

      battery = {
        format = "{capacity}% {icon}";
        format-icons = [ "" "" "" "" "" ];
        states = {
          warning = 30;
          critical = 15;
        };
      };

      network = {
        format-wifi = "{essid} ";
        format-ethernet = "{ifname} ";
        format-disconnected = "disconnected ⚠";
        tooltip = false;
      };

      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = "muted ";
        format-icons = {
          default = [ "" "" "" ];
        };
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      tray = {
        spacing = 8;
      };
    }];

    style = ''
      * {
        font-family: "sans-serif";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(20, 20, 20, 0.9);
        color: #cdd6f4;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      }

      #workspaces button {
        padding: 0 8px;
        color: #6c7086;
        background: transparent;
        border: none;
        border-radius: 0;
      }

      #workspaces button.active {
        color: #cdd6f4;
      }

      #clock, #battery, #network, #pulseaudio, #tray {
        padding: 0 12px;
        color: #cdd6f4;
      }

      #battery.warning { color: #f9e2af; }
      #battery.critical { color: #f38ba8; }
    '';
  };
}
