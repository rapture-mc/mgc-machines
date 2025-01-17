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
          system.hostname = "MGC-DRW-SEM01";
          users.admin-user = "${vars.adminUser}";
          bootloader.efi.enable = true;

          networking.static-ip = {
            enable = true;
            ipv4 = "${vars.networking.hostsAddr.MGC-DRW-SEM01.ipv4}";
            gateway = "${vars.networking.defaultGateway}";
            nameservers = vars.networking.nameServers;
            lan-domain = "${vars.networking.internalDomain}";
          };
        };

        services = {
          controller = {
            agent.enable = true;
            server.public-key = vars.authorizedDeployPubKeys;
          };

          semaphore = {
            enable = true;
            reverse-proxied = true;
            fqdn = "${vars.semaphoreFQDN}";
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
