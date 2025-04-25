{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/default/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };

    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/macbook/configuration.nix
        inputs.home-manager.darwinModules.home-manager
      ];
    };

    homeConfigurations.fedora = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-linux;
      extraSpecialArgs = {inherit inputs;};
      modules = [
        ./hosts/fedora/home.nix
      ];
    };

  };
}
