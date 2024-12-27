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
          system.hostname = "MGC-RVP-01";
          users.admin-user = "${vars.adminUser}";
          bootloader.efi.enable = true;
          networking.static-ip = {
            enable = true;
            ipv4 = "${vars.networking.hostsAddr.MGC-RVP-01.ipv4}";
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

          nginx = {
            enable = true;
            logo = true;
            gitea = {
              enable = true;
              ipv4 = "${vars.networking.hostsAddr.MGC-GIT-01.ipv4}";
              fqdn = "${vars.giteaFQDN}";
            };

            guacamole = {
              enable = true;
              ipv4 = "${vars.networking.hostsAddr.MGC-GUC-01.ipv4}";
              fqdn = "${vars.guacamoleFQDN}";
            };

            grafana = {
              enable = true;
              ipv4 = "${vars.networking.hostsAddr.MGC-GRF-01.ipv4}";
              fqdn = "${vars.grafanaFQDN}";
            };

            nextcloud = {
              enable = true;
              ipv4 = "${vars.networking.hostsAddr.MGC-NXC-01.ipv4}";
              fqdn = "${vars.nextcloudFQDN}";
            };

            semaphore = {
              enable = true;
              ipv4 = "${vars.networking.hostsAddr.MGC-DT-01.ipv4}";
              fqdn = "${vars.semaphoreFQDN}";
            };

            jenkins = {
              enable = true;
              ipv4 = "${vars.networking.hostsAddr.MGC-DT-01.ipv4}";
              fqdn = "${vars.jenkinsFQDN}";
            };
          };
        };
      };
    }
  ];
}
