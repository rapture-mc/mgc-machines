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

      environment.systemPackages = with nixpkgs.legacyPackages.x86_64-linux; [
        go
        gnucash
        pass
      ];

      megacorp = {
        config = {
          system.hostname = "MGC-LT01";

          users.admin-user = "${vars.adminUser}";

          bootloader.efi.enable = true;

          desktop.enable = true;
        };

        services = {
          controller = {
            agent.enable = true;
            server.public-key = vars.authorizedDeployPubKeys;
          };

          wireguard-client = {
            enable = true;
            private-key-file = "/home/benny/wireguard-keys/private";
            allowed-ips = ["192.168.1.0/24"];
            server = {
              ipv4 = "${vars.networking.wireguardPublicIP}";
              public-key = "${vars.keys.wireguardPubKeys.MGC-DRW-CTR01}";
            };
          };
        };

        virtualisation.whonix.enable = true;
      };
    }
  ];
}
