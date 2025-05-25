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
        (import ./secrets.nix {inherit inputs vars;})
        ./hardware-config.nix
      ];

      networking.hostName = "MGC-DRW-BST01";

      system.stateVersion = "24.11";

      megacorp = {
        config = {
          networking.static-ip = {
            enable = true;
            ipv4 = vars.networking.hostsAddr.MGC-DRW-BST01.eth.ipv4;
            interface = vars.networking.hostsAddr.MGC-DRW-BST01.eth.name;
            gateway = vars.networking.defaultGateway;
            lan-domain = vars.networking.internalDomain;
          };

          openssh = {
            enable = true;
            authorized-ssh-keys = vars.keys.authorizedBastionPubKeys;
            bastion = {
              enable = true;
              logo = true;
            };
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
