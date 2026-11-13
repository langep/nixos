# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
    ./hardware-configuration.nix
    ../common/default.nix
    ../common/hyprland.nix
    ../common/1password.nix
    ../common/networking.nix
  ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [
    "coretemp"
    "thinkpad_acpi"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.hostName = "thinkpad";

  # Firmware Updates
  services.fwupd.enable = true;

  # Battery state provider used by throttled over the system D-Bus.
  services.upower.enable = true;

  # Client for streaming games and the desktop from Sunshine hosts.
  environment.systemPackages = [ pkgs.moonlight-qt ];

  # Power Management
  services.tlp = {
    enable = true;
    settings = {
      # CPU scaling
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # CPU energy/performance policy
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Battery charge thresholds — good for ThinkPad
      # keeps battery between 40-80% to extend lifespan
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;

      # WiFi power save
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # Deep sleep
      MEM_SLEEP_MODE_ON_AC = "deep";
      MEM_SLEEP_MODE_ON_BAT = "deep";
    };
  };

  # Thermal Throttling
  services.thermald.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
