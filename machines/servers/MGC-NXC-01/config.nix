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
          system.hostname = "MGC-NXC-01";

          users.admin-user = "${vars.adminUser}";

          networking.static-ip = {
            enable = true;
            ipv4 = "${vars.networking.hostsAddr.MGC-NXC-01.ipv4}";
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

          nextcloud = {
            enable = true;
            package = nixpkgs.legacyPackages.x86_64-linux.nextcloud28;
            logo = true;
            reverse-proxied = true;
            fqdn = vars.nextcloudFQDN;
            trusted-proxies = ["${vars.networking.hostsAddr.MGC-RVP-01.ipv4}"];
            backups.enable = true;
          };
        };
      };
    }
  ];
}
