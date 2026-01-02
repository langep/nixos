{
  description = "NixOS System Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";	
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        thinkpad = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
	  specialArgs = { inherit inputs; };
          modules = [
            ./hosts/thinkpad/default.nix
          ];
        };
	wsl = nixpkgs.lib.nixosSystem {
	  system = "x86_64-linux";
	  specialArgs = { inherit inputs; };
	  modules = [
	    ./hosts/wsl/default.nix
	  ];
	};
      };
    };
}
