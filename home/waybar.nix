{
  lib,
  osConfig,
  ...
}:
{
  # Waybar's tray hosts nm-applet; clicking it opens the Wi-Fi network menu.
  services.network-manager-applet.enable = osConfig.networking.networkmanager.enable;

  programs.waybar = {
    enable = true;
    systemd.enable = true;

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
        ]
        ++ lib.optionals osConfig.hardware.bluetooth.enable [ "bluetooth" ]
        ++ [ "network" ]
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
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = " {capacity}%";
          format-full = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
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
          tooltip-format-wifi = "{ifname}: {essid} ({signalStrength}%)\n{ipaddr}";
          tooltip-format-ethernet = "{ifname}\n{ipaddr}";
          tooltip-format-disconnected = "Network disconnected";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = " {icon} {volume}%";
          format-muted = "󰖁 muted";
          tooltip-format = "{desc}";
          format-icons = {
            headphone = "";
            hands-free = "󰂑";
            headset = "󰂑";
            phone = "";
            portable = "";
            car = "";
            speaker = "";
            hdmi = "󰡁";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-right-click = "pavucontrol";
        };

        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-off = "󰂲";
          format-connected = "󰂱 {num_connections}";
          format-connected-battery = "󰂱 {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}";
          tooltip-format-enumerate-connected-battery = "{device_alias}: {device_battery_percentage}%";
          on-click = "blueman-manager";
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

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #bluetooth, #tray {
        padding: 0 8px;
        margin: 0 1px;
        border-radius: 0;
        background: @base00;
        color: @base05;
      }

      #battery.charging, #battery.plugged, #bluetooth.connected {
        color: @base0B;
      }

      #battery.warning:not(.charging) {
        color: @base09;
      }

      #battery.critical:not(.charging) {
        color: @base08;
      }

      #pulseaudio.muted, #bluetooth.disabled, #bluetooth.off {
        color: @base03;
      }

    '';
  };
}
