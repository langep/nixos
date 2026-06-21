# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../common/default.nix
    ../common/hyprland.nix
    ../common/1password.nix
    ../common/steam.nix
  ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [
    "amd_pstate=active"
    "nvidia-drm.fbdev=1"
    "quiet"
    "udev.log_priority=3"
  ];
  boot.consoleLogLevel = 3;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.hostName = "desktop";

  # Firmware Updates
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;
  hardware.cpu.amd.updateMicrocode = true; # CPU microcode

  # NVIDIA RTX 5090 (Blackwell — open modules required)
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true; # Steam
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
  };
  environment.variables = {
    # increase nvidia shader cache to 64GB to prevent frequent shader recompilations
    __GL_SHADER_DISK_CACHE_SIZE = "68719476736";
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  # SSD
  services.fstrim.enable = true;

  # Networking
  networking = {
    networkmanager.enable = false;
    useNetworkd = true;
    useDHCP = false;
  };

  systemd.network = {
    enable = true;
    networks."10-wired" = {
      matchConfig.Name = "enp7s0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
        DNS = [
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
      };
      dhcpV4Config = {
        UseDNS = false;
        RouteMetric = 10; # routing priority should we e.g. add wifi later
      };

      dhcpV6Config = {
        UseDNS = false;
      };

      ipv6AcceptRAConfig = {
        UseDNS = false;
      };
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "false";
  };

  # Docker
  virtualisation.docker = {
    enable = true;
    daemon.settings.features.cdi = true;
  };
  hardware.nvidia-container-toolkit.enable = true;
  users.users.langep.extraGroups = lib.mkAfter [ "docker" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
