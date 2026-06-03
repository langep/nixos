{ pkgs, ... }:
{
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
    "2606:4700:4700::1111"
  ];
  services.resolved.enable = true;
}
