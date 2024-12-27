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

      # services.earlyoom.enable = true;

      megacorp = {
        config = {
          system.hostname = "MGC-HVS-01";
          users.admin-user = "${vars.adminUser}";

          networking = {
            static-ip = {
              enable = true;
              interface = "${vars.networking.hostsAddr.MGC-HVS-01.int}";
              ipv4 = "${vars.networking.hostsAddr.MGC-HVS-01.ipv4}";
              gateway = "${vars.networking.defaultGateway}";
              nameservers = vars.networking.nameServers;
              lan-domain = "${vars.networking.internalDomain}";
              bridge.enable = true;
            };
          };

          desktop = {
            enable = true;
            xrdp = true;
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
        };

        virtualisation.hypervisor = {
          enable = true;
          logo = true;
          libvirt-users = [
            "${vars.adminUser}"
            "deploy"
          ];
        };
      };
    }
  ];
}
