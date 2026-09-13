{
  description = "NixOS System Flake";

  inputs = {
    # Common
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Thinkpad
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # WSL
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";

    # Theme
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code.url = "github:sadjow/claude-code-nix";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    revdiff.url = "github:umputun/revdiff/v1.12.0";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/desktop/default.nix
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            { home-manager.extraSpecialArgs = { inherit inputs; }; }
          ];
        };
        thinkpad = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/thinkpad/default.nix
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            { home-manager.extraSpecialArgs = { inherit inputs; }; }
          ];
        };
        wsl = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/wsl/default.nix
            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix
            { home-manager.extraSpecialArgs = { inherit inputs; }; }
          ];
        };
      };
    };
}
