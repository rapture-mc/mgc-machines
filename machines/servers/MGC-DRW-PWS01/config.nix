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
        ./hardware-config.nix
        (import ./backup.nix {inherit vars;})
        (import ./secrets.nix {inherit inputs;})
      ];

      megacorp = {
        config = {
          system = {
            enable = true;
            hostname = "MGC-DRW-PWS01";
          };

          bootloader = {
            enable = true;
            efi.enable = true;
          };

          users = {
            enable = true;
            admin-user = vars.adminUser;
          };

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
            server.public-key = vars.keys.deployPubKeys;
          };

          prometheus = {
            enable = true;
            node-exporter.enable = true;
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
