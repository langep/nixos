{ pkgs, ... }: {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.patlange = {
        isNormalUser = true;
        description = "Patrick Lange";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [];
    };

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Set your time zone.
    time.timeZone = "America/Los_Angeles";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.patlange = ../../home/default.nix;
    };
}