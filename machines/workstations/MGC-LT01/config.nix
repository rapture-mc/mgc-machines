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

      virtualisation.docker.enable = true;

      megacorp = {
        config = {
          system = {
            enable = true;
            hostname = "MGC-LT01";
          };

          bootloader = {
            enable = true;
            efi.enable = true;
          };

          users = {
            enable = true;
            admin-user = vars.adminUser;
          };

          openssh = {
            enable = true;
            authorized-ssh-keys = vars.keys.bastionPubKeys;
            bastion = {
              enable = true;
              logo = true;
            };
          };

          desktop.enable = true;
        };

        services = {
          controller = {
            agent.enable = true;
            server.public-key = vars.keys.deployPubKeys;
          };

          wireguard-client = {
            enable = true;
            ipv4 = vars.networking.hostsAddr.MGC-LT01.wireguard.ipv4;
            allowed-ips = ["${vars.networking.privateLANSubnet}"];
            server = {
              ipv4 = vars.networking.wireguardPublicIP;
              public-key = vars.keys.wireguardPubKeys.MGC-DRW-CTR01;
            };
          };

          comin = {
            enable = true;
            repo = "https://github.com/rapture-mc/mgc-machines";
          };
        };

        virtualisation.whonix.enable = true;
      };
    }
  ];
}
