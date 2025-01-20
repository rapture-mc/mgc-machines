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
          rebuild-machine.enable = true;

          wireguard-client = {
            enable = true;
            private-key-file = "/home/benny/wireguard-keys/private";
            server = {
              ipv4 = "${vars.networking.wireguardPublicIP}";
              public-key = "${vars.wireguardPubKeys.MGC-DRW-VPN01}";
            };
          };
        };

        virtualisation.whonix.enable = true;
      };
    }
  ];
}
