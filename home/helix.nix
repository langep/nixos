{ pkgs, ... }: {
  programs.helix= {
    enable = true;
    settings = {
      editor = {
        auto-format = true;
      };
    };
    languages.language = [{
      name = "nix";
      auto-format = true;
      formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
    }];
  };
}
