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
          system.hostname = "MGC-DRW-RST01";
          users.admin-user = vars.adminUser;
          bootloader.efi.enable = true;

          networking.static-ip = {
            enable = true;
            ipv4 = vars.networking.hostsAddr.MGC-DRW-RST01.eth.ipv4;
            interface = vars.networking.hostsAddr.MGC-DRW-RST01.eth.name;
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

          prometheus = {
            enable = true;
            node-exporter.enable = true;
          };

          restic.sftp-server = {
            enable = true;
            logo = true;
            authorized-keys = vars.keys.resticPubKeys;
          };
        };
      };
    }
  ];
}
