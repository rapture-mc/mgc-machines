{
  nixpkgs,
  megacorp,
  vars,
  ...
}: let
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
in nixpkgs.lib.nixosSystem {
  modules = [
    megacorp.nixosModules.default
    {
      imports = [
        ./hardware-config.nix
      ];

      environment.systemPackages = [pkgs.wireguard-tools];

      networking = {
        firewall.allowedUDPPorts = [51820];
        wireguard = {
          enable = true;
          interfaces.wg0 = {
            ips = ["10.100.0.1/24"];
            listenPort = 51820;
            postSetup = ''
              ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
            '';
            postShutdown = ''
              ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
            '';
            privateKeyFile = "/home/benny/wireguard-keys/private";
            peers = [
              {
                publicKey = "WybmIIlnKoaSpJZVLkw34RwhRhogfTbKXNEchGhrAXE=";
                allowedIPs = ["10.100.0.2/32"];
              }
            ];
          };
        };
        nat = {
          enable = true;
          internalInterfaces = ["wg0"];
          externalInterface = "ens3";
        };
      };

      megacorp = {
        virtualisation.guest.qemuConsole.enable = true;

        config = {
          system.hostname = "MGC-DRW-VPN01";
          users.admin-user = "${vars.adminUser}";
          bootloader.efi.enable = true;

          networking.static-ip = {
            enable = true;
            ipv4 = "${vars.networking.hostsAddr.MGC-DRW-VPN01.ipv4}";
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
        };
      };
    }
  ];
}
