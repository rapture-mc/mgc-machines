{
  nixpkgs,
  megacorp,
  vars,
  inputs,
  ...
}:
nixpkgs.lib.nixosSystem {
  modules = [
    megacorp.nixosModules.default
    {
      imports = [
        (import ../../base-config.nix {inherit vars;})
        (import ./backup.nix {inherit vars;})
        (import ./secrets.nix {inherit inputs;})
        ./hardware-config.nix
      ];

      networking.hostName = "MGC-DRW-FBR01";

      system.stateVersion = "24.11";

      megacorp = {
        config = {
          openssh = {
            enable = true;
            authorized-ssh-keys = vars.keys.bastionPubKey;
          };

          networking.static-ip = {
            enable = true;
            ipv4 = vars.networking.hostsAddr.MGC-DRW-FBR01.eth.ipv4;
            interface = vars.networking.hostsAddr.MGC-DRW-FBR01.eth.name;
            gateway = vars.networking.defaultGateway;
            nameservers = vars.networking.nameServers;
            lan-domain = vars.networking.internalDomain;
          };
        };

        services = {
          controller = {
            agent.enable = true;
            server.public-key = vars.keys.controllerPubKey;
          };

          file-browser = {
            enable = true;
            reverse-proxied = true;
            fqdn = vars.file-browserFQDN;
          };
        };
      };
    }
  ];
}
