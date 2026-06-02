{ pkgs, ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock"; # avoids starting multiple hyprlock instances
        before_sleep_cmd = "hyprlock"; # lock before suspend
        after_sleep_cmd = "hyprctl dispatch dpms on"; # turn monitors on
      };

      listener = [
        {
          timeout = 600; # 10 minutes
          on-timeout = "hyprlock";
        }
        {
          timeout = 900; # 15 minutes
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800; # 30 minutes
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
  };
}
