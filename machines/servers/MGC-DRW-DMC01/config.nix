{
  nixpkgs,
  pkgs,
  megacorp,
  vars,
  lib,
  inputs,
  ...
}:
nixpkgs.lib.nixosSystem {
  modules = [
    megacorp.nixosModules.default
    {
      imports = [
        (import ../../base-config.nix {inherit vars;})
        (import ./ldap {inherit nixpkgs pkgs;})
        (import ./secrets.nix {inherit inputs vars;})
        ./hardware-config.nix
      ];

      networking = {
        hostName = "MGC-DRW-DMC01";

        hosts = {
          "${vars.networking.hostsAddr.MGC-DRW-CTR01.eth.ipv4}" = ["MGC-DRW-CTR01"];
          "${vars.networking.hostsAddr.MGC-DRW-GRF01.eth.ipv4}" = ["MGC-DRW-GRF01"];
          "${vars.networking.hostsAddr.MGC-DRW-GUC01.eth.ipv4}" = ["MGC-DRW-GUC01"];
          "${vars.networking.hostsAddr.MGC-DRW-PWS01.eth.ipv4}" = ["MGC-DRW-PWS01"];
          "${vars.networking.hostsAddr.MGC-DRW-RST01.eth.ipv4}" = ["MGC-DRW-RST01"];
          "${vars.networking.hostsAddr.MGC-DRW-FBR01.eth.ipv4}" = ["MGC-DRW-FBR01"];
          "${vars.networking.hostsAddr.MGC-DRW-RVP01.eth.ipv4}" = ["MGC-DRW-RVP01"];
          "${vars.networking.hostsAddr.MGC-DRW-SEM01.eth.ipv4}" = ["MGC-DRW-SEM01"];
          "${vars.networking.hostsAddr.MGC-DRW-HVS01.eth.ipv4}" = ["MGC-DRW-HVS01"];
          "${vars.networking.hostsAddr.MGC-DRW-HVS02.eth.ipv4}" = ["MGC-DRW-HVS02"];
          "${vars.networking.hostsAddr.MGC-DRW-HVS03.eth.ipv4}" = ["MGC-DRW-HVS03"];
          "${vars.networking.hostsAddr.MGC-DRW-DMC01.eth.ipv4}" = ["MGC-DRW-DMC01"];
          "${vars.networking.hostsAddr.MGC-DRW-ZBX01.eth.ipv4}" = ["MGC-DRW-ZBX01"];
          "192.168.1.99" = ["MGC-DRW-FRW01"];
        };
      };

      system.stateVersion = "24.11";

      megacorp = {
        config = {
          networking.static-ip = {
            enable = true;
            ipv4 = vars.networking.hostsAddr.MGC-DRW-DMC01.eth.ipv4;
            interface = vars.networking.hostsAddr.MGC-DRW-DMC01.eth.name;
            gateway = vars.networking.defaultGateway;
            lan-domain = vars.networking.internalDomain;
          };

          bootloader.efi.enable = lib.mkForce false;

          openssh = {
            enable = true;
            authorized-ssh-keys = vars.keys.bastionPubKey;
          };
        };

        services = {
          comin = {
            enable = true;
            repo = "https://github.com/rapture-mc/mgc-machines";
          };

          dnsmasq = {
            enable = true;
            domain = vars.networking.internalDomain;
          };
        };
      };
    }
  ];
}
