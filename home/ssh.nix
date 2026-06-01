{ lib, config, osConfig, ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github.com" = {
        User = "git";
      };

      "*" = lib.hm.dag.entryAfter [ "github.com" ] ({
        ServerAliveInterval = 60;
      }
      // lib.optionalAttrs osConfig.programs._1password.enable {
        IdentityAgent = "${config.home.homeDirectory}/.1password/agent.sock";
      });
      
    };
    
  };
}
