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

      networking.hosts = {
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
        "192.168.1.99" = ["MGC-DRW-FRW01"];
      };

      megacorp = {
        config = {
          system.hostname = "MGC-DRW-BST01";
          users.admin-user = vars.adminUser;
          bootloader.efi.enable = true;

          networking.static-ip = {
            enable = true;
            ipv4 = vars.networking.hostsAddr.MGC-DRW-BST01.eth.ipv4;
            interface = vars.networking.hostsAddr.MGC-DRW-BST01.eth.name;
            gateway = vars.networking.defaultGateway;
            nameservers = ["127.0.0.1" "::1"];
            lan-domain = vars.networking.internalDomain;
          };
        };

        services = {
          controller = {
            agent.enable = true;
            server.public-key = vars.keys.deployPubKeys;
          };

          dnsmasq = {
            enable = true;
            domain = vars.networking.internalDomain;
          };

          sshd = {
            bastion = {
              enable = true;
              logo = true;
            };

            authorized-ssh-keys = vars.keys.bastionPubKeys;
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
