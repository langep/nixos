{
  description = "NixOS System Flake";

  inputs = {
    # Common
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
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
  };

  outputs =
    { self, nixpkgs, home-manager,... }@inputs: let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        thinkpad = nixpkgs.lib.nixosSystem {
          inherit system;
	        specialArgs = { inherit inputs; };
	        modules = [
            ./hosts/thinkpad/default.nix
	          home-manager.nixosModules.home-manager	          
	        ];
        };
        wsl = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/wsl/default.nix
            home-manager.nixosModules.home-manager            
          ];
        };
      };
    };
}
