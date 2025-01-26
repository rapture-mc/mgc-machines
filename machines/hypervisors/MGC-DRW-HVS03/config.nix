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
        config = {
          system.hostname = "MGC-DRW-HVS03";
          users.admin-user = "${vars.adminUser}";
          bootloader.efi.enable = true;

          networking = {
            static-ip = {
              enable = true;
              interface = "${vars.networking.hostsAddr.MGC-DRW-HVS03.int}";
              ipv4 = "${vars.networking.hostsAddr.MGC-DRW-HVS03.ipv4}";
              gateway = "${vars.networking.defaultGateway}";
              nameservers = vars.networking.nameServers;
              lan-domain = "${vars.networking.internalDomain}";
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
            server.public-key = vars.authorizedDeployPubKeys;
          };

          prometheus = {
            enable = true;
            node-exporter.enable = true;
          };
        };

        virtualisation.whonix.enable = true;
      };
    }
  ];
}
