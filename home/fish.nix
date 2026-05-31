{...}: {

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/langep/nixos#$(hostname)";
    };
  };

}
