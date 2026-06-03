{ pkgs, lib, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Login
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --asterisks --time --remember --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Video
  hardware.graphics.enable = true;

  # Authentication dialogs
  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    tuigreet
    libnotify
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  } // lib.optionalAttrs (builtins.elem "nvidia" config.services.xserver.videoDrivers) {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
}
