{ lib, pkgs, ... }:

let
  remoteDevSwayConfig = pkgs.writeText "moonshine-remote-dev-sway.conf" ''
    set $mod Mod4
    font pango:monospace 11

    default_border pixel 2
    default_floating_border normal 2
    focus_follows_mouse no
    output * bg #20242b solid_color

    # rz uses this hidden terminal to give launched applications a live PTY.
    for_window [app_id="rz-launcher"] move scratchpad

    bindsym $mod+Return exec ${pkgs.foot}/bin/foot --working-directory=/home/langep/Projects/zengine
    bindsym $mod+d exec ${pkgs.fuzzel}/bin/fuzzel
    bindsym $mod+Shift+q kill
    bindsym $mod+f fullscreen toggle
    bindsym $mod+Shift+e exec ${pkgs.sway}/bin/swaymsg exit

    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right
    bindsym $mod+Shift+h move left
    bindsym $mod+Shift+j move down
    bindsym $mod+Shift+k move up
    bindsym $mod+Shift+l move right

    # Each rz-launched app occupies its own workspace, so cycle workspaces as
    # if they were windows. Empty workspaces disappear after switching away.
    bindsym Mod1+Tab workspace next_on_output
    bindsym Mod1+Shift+Tab workspace prev_on_output

    bindsym $mod+1 workspace number 1
    bindsym $mod+2 workspace number 2
    bindsym $mod+3 workspace number 3
    bindsym $mod+4 workspace number 4
    bindsym $mod+Shift+1 move container to workspace number 1
    bindsym $mod+Shift+2 move container to workspace number 2
    bindsym $mod+Shift+3 move container to workspace number 3
    bindsym $mod+Shift+4 move container to workspace number 4

    # Support development tools which still require X11.
    xwayland enable
  '';
in
{
  # Sway runs nested inside Moonshine's isolated Wayland compositor. It does
  # not replace the normal Hyprland login session.
  programs.sway = {
    enable = true;
    xwayland.enable = true;
  };

  services.moonshine = {
    enable = true;
    user = "langep";

    # Expose GameStream only on the wired LAN, not on every interface.
    firewallInterfaces = [ "enp7s0" ];

    environment = {
      WLR_BACKENDS = "wayland";
      WLR_RENDERER = "gles2";
    };

    extraPackages = [
      pkgs.foot
      pkgs.fuzzel
      pkgs.sway
      pkgs.xwayland
    ];

    settings.application = [
      {
        title = "Remote Development";
        command = [
          "${pkgs.dbus}/bin/dbus-run-session"
          "--"
          "${pkgs.sway}/bin/sway"
          "--config"
          "${remoteDevSwayConfig}"
        ];
        working_directory = "/home/langep/Projects/zengine";
        steam_integration = false;
        stdout = "journal";
        stderr = "journal";
      }
    ];
  };

  # Needed for virtual input devices when Moonshine runs without an active
  # local graphical login.
  users.users.langep.extraGroups = lib.mkAfter [ "input" ];
}
