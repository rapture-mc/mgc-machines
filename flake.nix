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
    ...
  } @ inputs: let
    vars = import ./vars;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    # Helper function for importing different nixosConfigurations
    importMachineConfig = machineType: machineName:
      import ./machines/${machineType}/${machineName} {
        inherit inputs self vars megacorp nixpkgs pkgs terranix system;
      };
  in {
    # Machines currently managed under this Flake
    # Rebuild locally with "sudo nixos-rebuild switch --flake .#<machine-hostname>"
    nixosConfigurations = import ./machines {inherit importMachineConfig;};

    # For generating NixOS QCOW images for use with terraform + libvirt
    # Build with "nix build .#qcow"
    packages.${system}.qcow = nixos-generators.nixosGenerate {
      system = system;
      format = "qcow";
      modules = [
        megacorp.nixosModules.default
        {
          networking.hostName = "nixos";

          system.stateVersion = "24.11";

          megacorp = {
            virtualisation.qemu-guest.enable = true;

            config = {
              system.enable = true;
              bootloader.enable = false; # nixos-generator will handle bootloader configuration instead
              nixvim.enable = true;
              packages.enable = true;

              openssh = {
                enable = true;
                authorized-ssh-keys = vars.keys.bastionPubKey;
              };

              users = {
                enable = true;
                admin-user = "benny";
              };
            };
          };
        }
      ];
    };
  };
}
