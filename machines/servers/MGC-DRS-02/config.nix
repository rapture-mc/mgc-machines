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
        (import ./secrets.nix {inherit inputs;})
        (import ./backup.nix {inherit vars;})
      ];

      megacorp = {
        config = {
          system.hostname = "MGC-DRS-02";
          users.admin-user = "${vars.adminUser}";
          bootloader.efi.enable = true;
          ssh.accept-host-key = true;

          networking.static-ip = {
            enable = true;
            ipv4 = "${vars.networking.hostsAddr.MGC-DRS-02.ipv4}";
            gateway = "${vars.networking.defaultGateway}";
            nameservers = vars.networking.nameServers;
            lan-domain = "${vars.networking.internalDomain}";
          };
        };

        services = {
          rebuild-machine.enable = true;

          deploy-rs.server = {
            enable = true;
            logo = true;
          };

          gitea-runner = {
            enable = true;
            url = "${vars.giteaFQDN}";
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
