{
  description = "MGC NixOS Infrastructure";

  inputs = {
    megacorp.url = "github:rapture-mc/nixos-module";
    nixpkgs.follows = "megacorp/nixpkgs";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
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
    deploy-rs,
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
  in {
    # Machines currently managed under this Flake
    # Rebuild locally with "sudo nixos-rebuild switch --flake .#<machine-hostname>"
    nixosConfigurations = import ./machines {inherit importMachineConfig;};

    # Machines that are managed with deploy-rs
    # Deploy with "deploy-rs .#<machine-hostname> -s"
    deploy.nodes = import ./machines/deploy.nix {inherit importMachineConfig;};

    # Check deploy-rs configuration beforehand (recommened by deploy-rs manual)
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
