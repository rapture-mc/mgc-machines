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
      ];

      # services.syncthing = {
      #   enable = true;
      #   guiAddress = "${vars.networking.hostsAddr.MGC-DRS-01.ipv4}:8384";
      # };
      #
      # networking.firewall.allowedTCPPorts = [ 8384 ];

      megacorp = {
        config = {
          system.hostname = "MGC-DRS-01";
          users.admin-user = "${vars.adminUser}";
          bootloader.efi.enable = true;
          ssh.accept-host-key = true;

          networking.static-ip = {
            enable = true;
            ipv4 = "${vars.networking.hostsAddr.MGC-DRS-01.ipv4}";
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
            labels = ["MGC-DRS-01:host"];
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
