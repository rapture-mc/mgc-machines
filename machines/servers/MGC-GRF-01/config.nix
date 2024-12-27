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
          system.hostname = "MGC-GRF-01";

          users.admin-user = "${vars.adminUser}";

          networking.static-ip = {
            enable = true;
            ipv4 = "${vars.networking.hostsAddr.MGC-GRF-01.ipv4}";
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

          grafana = {
            enable = true;
            logo = true;
            reverse-proxied = true;
            fqdn = "${vars.grafanaFQDN}";
          };

          prometheus = {
            enable = true;
            scraper = {
              enable = true;
              targets = [
                "MGC-HVS-01:9002"
                "MGC-HVS-02:9002"
                "MGC-HVS-03:9002"
                "${vars.networking.hostsAddr.MGC-BST-01.ipv4}:9002"
                "MGC-DRS-01:9002"
                "MGC-DRS-02:9002"
                "MGC-RVP-01:9002"
                "MGC-GIT-01:9002"
                "MGC-GUC-01:9002"
                "MGC-NXC-01:9002"
                "MGC-PWS-01:9002"
                "MGC-RST-01:9002"
                "MGC-RVP-01:9002"
              ];
            };
          };
        };
      };
    }
  ];
}
