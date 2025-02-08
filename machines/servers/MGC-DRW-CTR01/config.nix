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
          system.hostname = "MGC-DRW-CTR01";
          users.admin-user = vars.adminUser;
          bootloader.efi.enable = true;
          ssh.accept-host-key = true;

          networking.static-ip = {
            enable = true;
            ipv4 = vars.networking.hostsAddr.MGC-DRW-CTR01.eth.ipv4;
            interface = vars.networking.hostsAddr.MGC-DRW-CTR01.eth.name;
            gateway = vars.networking.defaultGateway;
            nameservers = vars.networking.nameServers;
            lan-domain = vars.networking.internalDomain;
          };
        };

        services = {
          rebuild-machine.enable = true;

          controller.server = {
            enable = true;
            logo = true;
          };

          wireguard-server = {
            enable = true;
            peers = [
              {
                publicKey = vars.keys.wireguardPubKeys.MGC-LT01;
                allowedIPs = ["${vars.networking.hostsAddr.MGC-LT01.wireguard.ipv4}/32"];
              }
            ];
          };

          prometheus = {
            enable = true;
            node-exporter.enable = true;
          };

          syncthing = {
            enable = true;
            devices = {
              MGC-DRW-HVS02 = {
                id = vars.keys.syncthingIDs.MGC-DRW-HVS02;
                autoAcceptFolders = true;
              };
            };
            folders = {
              "Sync" = {
                path = "/home/${vars.adminUser}/Sync";
                devices = [
                  "MGC-DRW-HVS02"
                ];
              };
            };
          };
        };
      };
    }
  ];
}
