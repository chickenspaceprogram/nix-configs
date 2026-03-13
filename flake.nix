{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/1412caf7bf9e660f2f962917c14b1ea1c3bc695e;
  inputs.home-manager.url = github:nix-community/home-manager;

  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ];
    };
  };
}
