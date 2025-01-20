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

      networking.firewall = {
        allowedUDPPorts = [ 51820 ];
      };

      # networking = {
      #   wireguard = {
      #     enable = true;
      #     interfaces = {
      #       wg0 = {
      #         ips = [ "10.100.0.2/24" ];
      #         listenPort = 51820;
      #         privateKeyFile = "/home/benny/wireguard-keys/private";
      #         peers = [
      #           {
      #             publicKey = "CthODhxdRHTxTAdqcRlqYAYkRBXMuDFA7AkQfyIrTxY=";
      #             allowedIPs = [ "10.100.0.0/24" ];
      #             endpoint = "123.243.147.17:51820";
      #             persistentKeepalive = 25;
      #           }
      #         ];
      #       };
      #     };
      #   };
      # };

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
            ipv4 = "${vars.networking.hostsAddr.MGC-LT01.wireguard.ipv4}";
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
