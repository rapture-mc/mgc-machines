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
        (import ../../base-config.nix {inherit vars;})
        (import ./ldap {inherit nixpkgs pkgs;})
        (import ./secrets.nix {inherit inputs vars;})
        (import ./dns.nix {inherit megacorp vars;})
        ./hardware-config.nix
      ];

      networking.hostName = "MGC-DRW-DMC01";

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

          bootloader.efi.enable = nixpkgs.lib.mkForce false;

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
        };
      };
    }
  ];
}
