{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  ethernetStatus = pkgs.writeShellApplication {
    name = "waybar-ethernet-status";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.gawk
      pkgs.iproute2
      pkgs.jq
    ];
    text = ''
      network_interface=enp7s0
      sysfs_interface="/sys/class/net/$network_interface"

      if [[ ! -d "$sysfs_interface" ]] || [[ "$(<"$sysfs_interface/operstate")" != "up" ]]; then
        jq -cn '{text:"disconnected ⚠",tooltip:"enp7s0 is disconnected",class:"disconnected"}'
        exit 0
      fi

      speed_mbps="$(<"$sysfs_interface/speed")"
      if (( speed_mbps % 1000 == 0 )); then
        speed_label="$((speed_mbps / 1000))G"
      else
        speed_label="$((speed_mbps / 1000)).$(((speed_mbps % 1000) / 100))G"
      fi

      ipv4_address="$(ip -4 -brief address show dev "$network_interface" | awk '{print $3}')"
      gateway="$(ip -4 route show default dev "$network_interface" | awk '/^default/ { print $3; exit }')"
      rx_errors="$(<"$sysfs_interface/statistics/rx_errors")"
      tx_errors="$(<"$sysfs_interface/statistics/tx_errors")"

      module_class=connected
      if (( rx_errors > 0 || tx_errors > 0 )); then
        module_class=errors
      fi

      tooltip="Interface: $network_interface\nSpeed: $speed_mbps Mb/s\nIPv4: ''${ipv4_address:-none}\nGateway: ''${gateway:-none}\nRX errors: $rx_errors\nTX errors: $tx_errors\n\nClick to capture network diagnostics"
      jq -cn \
        --arg text "$network_interface $speed_label" \
        --arg tooltip "$tooltip" \
        --arg class "$module_class" \
        '{text:$text,tooltip:$tooltip,class:$class}'
    '';
  };
in
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
        ]
        ++ lib.optionals (osConfig.networking.hostName == "desktop") [ "custom/ethernet" ]
        ++ lib.optionals (osConfig.networking.hostName != "desktop") [ "network" ]
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

        "custom/ethernet" = {
          exec = lib.getExe ethernetStatus;
          return-type = "json";
          interval = 5;
          on-click = "foot fish -c '/home/langep/nixos/scripts/network-debug.fish; read -P \"Press Enter to close\"'";
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

      #clock, #battery, #cpu, #memory, #network, #custom-ethernet, #pulseaudio, #tray {
        padding: 0 8px;
        margin: 0 1px;
        border-radius: 0;
        background: @base00;
        color: @base05;
      }

      #custom-ethernet.errors, #custom-ethernet.disconnected {
        color: @base08;
      }
    '';
  };
}
