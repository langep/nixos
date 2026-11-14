{ pkgs, ... }:
{
  programs.steam.enable = true;
  programs.gamemode.enable = true;

  # Stream this machine to Moonlight clients. The capability is needed for
  # Sunshine's KMS screen capture under Wayland.
  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
    package = pkgs.sunshine.override { cudaSupport = true; };
  };

  environment.systemPackages = with pkgs; [
    beyond-all-reason
    lutris
    mangohud
    moonlight-qt
    protonup-qt
    # Run Windows-only development utilities such as the EOS Dev Auth Tool.
    wineWow64Packages.stable
  ];
}
