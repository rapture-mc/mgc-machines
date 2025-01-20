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
        virtualisation.guest.qemuConsole.enable = true;

        config = {
          system.hostname = "MGC-DRW-VPN01";
          users.admin-user = "${vars.adminUser}";
          bootloader.efi.enable = true;

          networking.static-ip = {
            enable = true;
            ipv4 = "${vars.networking.hostsAddr.MGC-DRW-VPN01.eth.ipv4}";
            gateway = "${vars.networking.defaultGateway}";
            nameservers = vars.networking.nameServers;
            lan-domain = "${vars.networking.internalDomain}";
          };
        };

        services = {
          controller = {
            agent.enable = true;
            server.public-key = vars.authorizedDeployPubKeys;
          };

          prometheus = {
            enable = true;
            node-exporter.enable = true;
          };

          wireguard-server = {
            enable = true;
            private-key-file = "/home/benny/wireguard-keys/private";
            peers = [
              {
                publicKey = "${vars.wireguardPubKeys.MGC-LT01}";
                allowedIPs = ["${vars.networking.hostsAddr.MGC-LT01.wireguard.ipv4}/32"];
              }
            ];
          };
        };
      };
    }
  ];
}
