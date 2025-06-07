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
        ../../qemu-hardware-config.nix
        (import ../../base-config.nix {inherit vars;})
        (import ./backup.nix {inherit vars;})
        (import ./secrets.nix {inherit vars inputs;})
      ];

      networking.hostName = "MGC-DRW-PWS01";

      system.stateVersion = "24.11";

      users.ldap = {
        enable = true;
        server = "ldap://mgc-drw-hvs01";
        base = "dc=megacorp,dc=industries";
      };

      megacorp = {
        config = {
          bootloader.enable = true;

          networking.static-ip = {
            enable = true;
            ipv4 = vars.networking.hostsAddr.MGC-DRW-PWS01.eth.ipv4;
            interface = vars.networking.hostsAddr.MGC-DRW-PWS01.eth.name;
            gateway = vars.networking.defaultGateway;
            nameservers = vars.networking.nameServers;
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

          password-store = {
            enable = true;
            logo = true;
          };
        };

        virtualisation.qemu-guest.enable = true;
      };
    }
  ];
}
