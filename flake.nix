{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixos-generators, ... }: {
    nixosConfigurations = {
      endor = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./configuration.nix ./containers ];
      };
    };

    packages.aarch64-linux= {
      endor = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        modules = [ ./configuration.nix ./containers ];
        format = "sd-aarch64";
      };
    };
  };
}
