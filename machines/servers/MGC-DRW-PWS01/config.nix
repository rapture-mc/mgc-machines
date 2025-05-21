{
  nixpkgs,
  megacorp,
  vars,
  inputs,
  pkgs,
  ...
}:
nixpkgs.lib.nixosSystem {
  modules = [
    megacorp.nixosModules.default
    {
      imports = [
        (import ../../base-config.nix {inherit vars;})
        (import ./backup.nix {inherit vars;})
        (import ./secrets.nix {inherit vars inputs;})
        ./hardware-config.nix
      ];

      networking.hostName = "MGC-DRW-PWS01";

      system.stateVersion = "24.11";

      security.ipa = {
        enable = true;
        server = "MGC-DRW-HVS02.megacorp.industries";
        domain = "megacorp.industries";
        realm = "MEGACORP.INDUSTRIES";
        certificate = pkgs.fetchurl {
          url = "http://localhost/ipa/config/ca.crt";
          sha256 = "";
        };
        basedn = "dc=megacorp,dc=industries";
      };

      megacorp = {
        config = {
          openssh = {
            enable = true;
            authorized-ssh-keys = vars.keys.bastionPubKey;
          };

          networking.static-ip = {
            enable = true;
            ipv4 = vars.networking.hostsAddr.MGC-DRW-PWS01.eth.ipv4;
            interface = vars.networking.hostsAddr.MGC-DRW-PWS01.eth.name;
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

          comin = {
            enable = true;
            repo = "https://github.com/rapture-mc/mgc-machines";
          };

          password-store = {
            enable = true;
            logo = true;
          };
        };
      };
    }
  ];
}
