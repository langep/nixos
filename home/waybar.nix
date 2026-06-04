{ lib, osConfig, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings = [
      {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 4;

        modules-center = [ "hyprland/workspaces" ];
        modules-left = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "network"
        ]
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
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
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
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-right-click = "pavucontrol";
        };

        tray = {
          spacing = 8;
        };
      }
    ];
    style = ''
      window#waybar {
        background-color: @base00;
        color: @base05;
        padding: 0 8px;     /* left/right padding on the bar itself */
      }

      #workspaces button {
        padding: 0 6px;
        color: @base04;
        background: transparent;
        border: none;
        border-radius: 0;
        margin: 0;
      }

      #workspaces button.active {
        color: @base0D;
        border-bottom: 2px solid @base0D;
        border-radius: 0;
      }

      #workspaces button:hover {
        background: @base01;
        color: @base05;
        border-radius: 0;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray {
        padding: 0 8px;
        margin: 0 1px;
        border-radius: 0;
        background: @base00;
        color: @base05;
      }
    '';
  };
}
