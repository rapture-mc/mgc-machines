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

      networking.hostName = "MGC-DRW-HVS02";

      system.stateVersion = "24.05";

      megacorp = {
        config = {
          networking = {
            static-ip = {
              enable = true;
              ipv4 = vars.networking.hostsAddr.MGC-DRW-HVS02.eth.ipv4;
              interface = vars.networking.hostsAddr.MGC-DRW-HVS02.eth.name;
              gateway = vars.networking.defaultGateway;
              nameservers = vars.networking.nameServers;
              lan-domain = vars.networking.internalDomain;
              bridge.enable = true;
            };
          };

          openssh = {
            enable = true;
            authorized-ssh-keys = vars.keys.bastionPubKey;
          };

          desktop = {
            enable = true;
            xrdp = true;
          };
        };

        services = {
          controller = {
            agent.enable = true;
            server.public-key = vars.keys.deployPubKeys;
          };

          syncthing = {
            enable = true;
            devices = {
              MGC-DRW-CTR01 = {
                id = vars.keys.syncthingIDs.MGC-DRW-CTR01;
                autoAcceptFolders = true;
              };
            };

            folders = {
              "Sync" = {
                path = "/home/${vars.adminUser}/Sync";
                devices = [
                  "MGC-DRW-CTR01"
                ];
              };
            };
          };
        };

        virtualisation.hypervisor = {
          enable = true;
          logo = true;
          libvirt-users = [
            "${vars.adminUser}"
            "controller"
          ];
        };
      };
    }
  ];
}
