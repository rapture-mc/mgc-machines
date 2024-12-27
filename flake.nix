{
  description = "MGC NixOS Infrastructure";

  inputs = {
    megacorp.url = "git+https://gitea.megacorp.industries/megacorp/nixos";
    nixpkgs.follows = "megacorp/nixpkgs";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "megacorp/nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "megacorp/nixpkgs";
    };

    terranix = {
      url = "github:terranix/terranix";
      inputs.nixpkgs.follows = "megacorp/nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "megacorp/nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    megacorp,
    nixos-generators,
    deploy-rs,
    terranix,
    ...
  } @ inputs: let
    vars = import ./vars;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    # Helper function for importing different nixosConfigurations
    importMachineConfig = machineType: machineName: configType:
      import ./machines/${machineType}/${machineName}/${configType}.nix {
        inherit inputs self vars megacorp nixpkgs deploy-rs pkgs;
      };

    # Helper function for importing different Terraform configurations
    importTerraformConfig = machineName: action:
      import ./terranix/${machineName}/terranix.nix {
        inherit terranix pkgs system machineName action;
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
    # Run with "nix run .#<machine-name>-apply"
    apps.${system} = import ./terranix {inherit importTerraformConfig;};

    # For generating NixOS QCOW EFI images for use with terraform + libvirt
    # Build with "nix build .#qcow-efi"
    packages.${system}.qcow-efi = nixos-generators.nixosGenerate {
      system = "${system}";
      format = "qcow-efi";
      modules = [
        megacorp.nixosModules.default
        {
          megacorp.config = {
            users.admin-user = "benny";
            bootloader.enable = false;
          };
        }
      ];
    };
  };
}
