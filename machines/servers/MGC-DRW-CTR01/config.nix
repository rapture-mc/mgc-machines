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

      networking.hostName = "MGC-DRW-CTR01";

      system.stateVersion = "24.11";

      megacorp = {
        config = {
          openssh = {
            enable = true;
            auto-accept-server-keys = true;
            authorized-ssh-keys = vars.keys.bastionPubKey;
          };

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
          controller.server = {
            enable = true;
            logo = true;
          };

          wireguard-server = {
            enable = true;
            peers = [
              {
                publicKey = vars.keys.wireguardPubKeys.MGC-LT01;
                allowedIPs = [
                  "${vars.networking.hostsAddr.MGC-LT01.wireguard.ipv4}/32"
                  "10.100.0.3/32"
                ];
              }
            ];
          };

          comin = {
            enable = true;
            repo = "https://github.com/rapture-mc/mgc-machines";
          };
        };
      };
    }
  ];
}
