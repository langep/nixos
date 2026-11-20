{ lib, config, osConfig, ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "github.com" = {
        User = "git";
      };

      "desktop" = lib.mkIf (osConfig.networking.hostName == "thinkpad") {
        HostName = "desktop.local";
        User = "langep";
        ForwardAgent = false;
      };

      "*" = lib.hm.dag.entryAfter [ "github.com" "desktop" ] ({
        ServerAliveInterval = 60;
      }
      // lib.optionalAttrs osConfig.programs._1password.enable {
        IdentityAgent = "${config.home.homeDirectory}/.1password/agent.sock";
      });
      
    };
    
  };
}
