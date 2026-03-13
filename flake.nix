{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/d46dae8b88b3d652ef81dce2609dc85e82b1f85b;
  inputs.home-manager.url = github:nix-community/home-manager/release-25.11;

  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ];
    };
  };
}
