{
  nixpkgs,
  megacorp,
  vars,
  inputs,
  ...
}:
nixpkgs.lib.nixosSystem {
  modules = [
    megacorp.nixosModules.default
    {
      imports = [
        ./hardware-config.nix
        (import ./backup.nix {inherit vars;})
        (import ./secrets.nix {inherit inputs;})
      ];

      megacorp = {
        config = {
          system.hostname = "MGC-DRW-HVS01";
          users.admin-user = vars.adminUser;
          bootloader.efi.enable = true;

          networking = {
            static-ip = {
              enable = true;
              ipv4 = vars.networking.hostsAddr.MGC-DRW-HVS01.eth.ipv4;
              interface = vars.networking.hostsAddr.MGC-DRW-HVS01.eth.name;
              gateway = vars.networking.defaultGateway;
              nameservers = vars.networking.nameServers;
              lan-domain = vars.networking.internalDomain;
              bridge.enable = true;
            };
          };

          desktop = {
            enable = true;
            xrdp = true;
          };
        };

        services = {
          controller = {
            agent.enable = true;
            server.public-key = vars.keys.deployPubKeys;
          };

          prometheus = {
            enable = true;
            node-exporter.enable = true;
          };
        };

        virtualisation.hypervisor = {
          enable = true;
          logo = true;
          libvirt-users = [
            "${vars.adminUser}"
          ];
        };
      };
    }
  ];
}
