{
  description = "MGC NixOS Infrastructure";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-24.11";
      rev = "04ef94c4c1582fd485bbfdb8c4a8ba250e359195";
    };

    megacorp = {
      url = "github:rapture-mc/nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
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

    nixos-hardware = {
      url = "github:nixos/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    megacorp,
    deploy-rs,
    nixos-generators,
    terranix,
    nixos-hardware,
    ...
  } @ inputs: let
    vars = import ./vars;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    # Helper function for importing different nixosConfigurations
    importMachineConfig = machineType: machineName: configType:
      import ./machines/${machineType}/${machineName}/${configType}.nix {
        inherit inputs self vars megacorp nixpkgs deploy-rs nixos-hardware pkgs terranix system;
      };

    # Helper function for importing different Terraform configurations
    importTerraformConfig = machineName: action:
      import ./infra/${machineName}/terranix.nix {
        inherit terranix pkgs system machineName action vars;
      };
  in {
    # Machines currently managed under this Flake
    # Rebuild locally with "sudo nixos-rebuild switch --flake .#<machine-hostname>"
    nixosConfigurations = import ./machines {inherit importMachineConfig;};

    # Machines that are managed with deploy-rs
    # Deploy with "deploy-rs .#<machine-hostname> -s"
    deploy.nodes = import ./machines/deploy.nix {inherit importMachineConfig;};

    # Check deploy-rs configuration beforehand (recommened by deploy-rs manual)
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    # Nix commands to create/destroy Terraform infrastructure
    # Run with "nix run .#<hypervisor-name>-apply"
    apps.${system} = import ./infra {inherit importTerraformConfig;};

    # For generating NixOS QCOW images for use with terraform + libvirt
    # Build with "nix build .#qcow"
    packages.${system}.qcow = nixos-generators.nixosGenerate {
      system = "${system}";
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
                authorized-ssh-keys = [
                  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzlYmoWjZYFeCNdMBCHBXmqpzK1IBmRiB3hNlsgEtre benny@MGC-DRW-BST01"
                ];
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
