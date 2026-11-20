{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../common/default.nix
    ../common/hyprland.nix
    ../common/1password.nix
    ../common/networking.nix
  ];

  networking.hostName = "steam-machine";

  # UEFI boot; hardware-configuration.nix supplies the machine's filesystems.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Intel CPU support. This does not depend on knowing the exact i7 model.
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  # RTX 2080 (Turing). Use NVIDIA's proprietary kernel module for this GPU.
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Native games plus a controller-friendly Gamescope session for the TV.
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    moonlight-qt
    mangohud
    protonup-qt
  ];

  # Find the desktop's Sunshine server over mDNS on the local network.
  services.avahi = {
    enable = true;
    openFirewall = true;
    nssmdns4 = true;
  };

  services.fstrim.enable = true;
  services.fwupd.enable = true;

  system.stateVersion = "25.11";
}
