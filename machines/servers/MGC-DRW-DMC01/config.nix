{
  nixpkgs,
  pkgs,
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
        ../../qemu-hardware-config.nix
        (import ../../base-config.nix {inherit vars;})
        (import ./secrets.nix {inherit inputs vars;})
        # (import ./ldap {inherit nixpkgs pkgs;})
        (import ./dns.nix {inherit megacorp vars;})
      ];

      networking.hostName = "MGC-DRW-DMC01";

      system.stateVersion = "24.11";

      megacorp = {
        config = {
          bootloader.enable = true;

          networking.static-ip = {
            enable = true;
            ipv4 = vars.networking.hostsAddr.MGC-DRW-DMC01.eth.ipv4;
            interface = vars.networking.hostsAddr.MGC-DRW-DMC01.eth.name;
            gateway = vars.networking.defaultGateway;
            lan-domain = vars.networking.internalDomain;
          };

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

          domain-controller = {
            enable = true;
            domain-component = "dc=megacorp,dc=industries";
            logo = true;
          };
        };

        virtualisation.qemu-guest.enable = true;
      };
    }
  ];
}
