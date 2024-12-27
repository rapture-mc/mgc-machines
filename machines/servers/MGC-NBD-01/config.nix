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

      systemd.services."acme-${vars.networking.hostsAddr.MGC-NBD-01.ipv4}".serviceConfig = { SuccessExitStatus = 10; };

      megacorp = {
        config = {
          system.hostname = "MGC-NBD-01";
          users.admin-user = "${vars.adminUser}";
          bootloader.efi.enable = true;

          networking.static-ip = {
            enable = true;
            ipv4 = "${vars.networking.hostsAddr.MGC-NBD-01.ipv4}";
            gateway = "${vars.networking.defaultGateway}";
            nameservers = vars.networking.nameServers;
            lan-domain = "${vars.networking.internalDomain}";
          };
        };

        services = {
          deploy-rs = {
            agent.enable = true;
            server.public-key = vars.authorizedDeployPubKeys;
          };

          prometheus = {
            enable = true;
            node-exporter.enable = true;
          };

          zabbix = {
            server = {
              enable = true;
              fqdn = "${vars.networking.hostsAddr.MGC-NBD-01.ipv4}";
            };

            agent.enable = true;
          };
        };
      };
    }
  ];
}
