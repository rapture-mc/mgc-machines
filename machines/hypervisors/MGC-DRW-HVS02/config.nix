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

      nixpkgs.config.allowUnfree = true;

      networking.hostName = "MGC-DRW-HVS02";

      system.stateVersion = "24.05";


      # The Ethernet card will suddenly stop working if too much data is transmitted over the link at one time. See https://www.reddit.com/r/Proxmox/comments/1drs89s/intel_nic_e1000e_hardware_unit_hang/?rdt=43359 for more info.
      systemd.services.fix-ethernet-bug = {
        enable = true;
        description = "This service provides a dirty hack to fix the Ethernet card on the Intel NUC (NUC10i5FNK).";
        path = [ nixpkgs.legacyPackages.x86_64-linux.ethtool ];
        serviceConfig.ExecStart = "ethtool -K ${vars.networking.hostsAddr.MGC-DRW-HVS02.eth.name} tso off gso off";
      };

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

          comin = {
            enable = true;
            repo = "https://github.com/rapture-mc/mgc-machines";
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
