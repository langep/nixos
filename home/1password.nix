{ config, ... }: {
  # Need to manually enable 1Password -> Settings -> Developer -> Use the SSH agent
  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent ${config.home.homeDirectory}/.1password/agent.sock
    '';
  };
}
