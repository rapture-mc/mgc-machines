{
  nixpkgs,
  megacorp,
  vars,
  microvm,
  ...
}:
nixpkgs.lib.nixosSystem {
  modules = [
    megacorp.nixosModules.default
    {
      imports = [
        (import ../../base-config.nix {inherit vars;})
        ./hardware-config.nix
        microvm.nixosModules.host
      ];

      networking.hostName = "MGC-DRW-HVS02";

      system.stateVersion = "24.05";

      systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";

      # systemd.services.NetworkManager-wait-online.serviceConfig.SuccessExitStatus = 1;

      networking.nameservers = ["192.168.1.35"];

      networking.useDHCP = false;

      systemd.network = {
        enable = true;

        netdevs.br0 = {
          enable = true;
          netdevConfig = {
            Kind = "bridge";
            Name = "br0";
          };
        };

        networks = {
          br0 = {
            matchConfig = {
              Name = "br0";
            };

            networkConfig = {
              DHCP = "no";
              DNS = "192.168.1.99";
              Address = "192.168.1.16/24";
            };

            routes = [
              {
                Destination = "0.0.0.0/0";
                Gateway = "192.168.1.99";
              }
            ];
          };

          eno1 = {
            matchConfig = {
              Name = "eno1";
            };

            networkConfig = {
              Bridge = "br0";
              DHCP = "no";
            };
          };
        };
      };

      networking.useNetworkd = true;

      megacorp = {
        config = {
          # networking = {
          #   static-ip = {
          #     enable = true;
          #     ipv4 = vars.networking.hostsAddr.MGC-DRW-HVS02.eth.ipv4;
          #     interface = vars.networking.hostsAddr.MGC-DRW-HVS02.eth.name;
          #     gateway = vars.networking.defaultGateway;
          #     nameservers = vars.networking.nameServers;
          #     lan-domain = vars.networking.internalDomain;
          #     bridge.enable = true;
          #   };
          # };

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
