{
  description = "MGC NixOS Infrastructure";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-25.05";
      rev = "da303f71c4f9673a7d718396fb23f74679ae4fb0";
    };

    megacorp = {
      url = "github:rapture-mc/nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    megacorp,
    nixos-generators,
    terranix,
    sops-nix,
    ...
  }: let
    vars = import ./vars;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    # Helper function for importing different nixosConfigurations
    importMachineConfig = machineType: machineName:
      import ./machines/${machineType}/${machineName} {
        inherit self vars megacorp sops-nix nixpkgs pkgs terranix system;
      };
  in {
    # Machines currently managed under this Flake
    # Rebuild locally with "sudo nixos-rebuild switch --flake .#<machine-hostname>"
    nixosConfigurations = import ./machines {inherit importMachineConfig;};

    # For generating Megacorp NixOS VM images
    # Build with "nix build .#<image-type>"
    packages.${system} = import ./nixos-images.nix {inherit system megacorp nixos-generators vars;};
  };
}
