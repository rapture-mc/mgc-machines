{
  nixpkgs,
  megacorp,
  vars,
  ...
}:
nixpkgs.lib.nixosSystem {
  modules = [
    megacorp.nixosModules.default
    {
      imports = [
        ./hardware-config.nix
      ];

      megacorp = {
        virtualisation.guest.qemuConsole.enable = true;

        config = {
          system.hostname = "MGC-DRW-GRF01";
          users.admin-user = vars.adminUser;
          bootloader.efi.enable = true;

          networking.static-ip = {
            enable = true;
            ipv4 = vars.networking.hostsAddr.MGC-DRW-GRF01.eth.ipv4;
            interface = vars.networking.hostsAddr.MGC-DRW-GRF01.eth.name;
            gateway = vars.networking.defaultGateway;
            nameservers = vars.networking.nameServers;
            lan-domain = vars.networking.internalDomain;
          };
        };

        services = {
          controller = {
            agent.enable = true;
            server.public-key = vars.keys.deployPubKeys;
          };

          grafana = {
            enable = true;
            logo = true;
            reverse-proxied = true;
          };

          prometheus = {
            enable = true;
            node-exporter.enable = true;
          };
        };
      };
    }
  ];
}
