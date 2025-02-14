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
        (import ../../base-config.nix {inherit vars;})
        ./hardware-config.nix
      ];

      networking.hostName = "MGC-DRW-RVP01";

      megacorp = {
        config = {
          openssh = {
            enable = true;
            authorized-ssh-keys = vars.keys.bastionPubKey;
          };

          networking.static-ip = {
            enable = true;
            ipv4 = vars.networking.hostsAddr.MGC-DRW-RVP01.eth.ipv4;
            interface = vars.networking.hostsAddr.MGC-DRW-RVP01.eth.name;
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

          nginx = {
            enable = true;
            logo = true;
            guacamole = {
              enable = true;
              ipv4 = vars.networking.hostsAddr.MGC-DRW-GUC01.eth.ipv4;
              fqdn = vars.guacamoleFQDN;
            };

            file-browser = {
              enable = true;
              ipv4 = vars.networking.hostsAddr.MGC-DRW-FBR01.eth.ipv4;
              fqdn = vars.file-browserFQDN;
            };

            semaphore = {
              enable = true;
              ipv4 = vars.networking.hostsAddr.MGC-DRW-SEM01.eth.ipv4;
              fqdn = vars.semaphoreFQDN;
            };

            grafana = {
              enable = true;
              ipv4 = vars.networking.hostsAddr.MGC-DRW-GRF01.eth.ipv4;
              fqdn = vars.grafanaFQDN;
            };

            zabbix = {
              enable = true;
              ipv4 = vars.networking.hostsAddr.MGC-DRW-ZBX01.eth.ipv4;
              fqdn = vars.zabbixFQDN;
            };
          };
        };
      };
    }
  ];
}
