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

      networking.hosts = {
        "${vars.networking.hostsAddr.MGC-DRW-CTR01.ipv4}" = ["MGC-DRW-CTR01"];
        "${vars.networking.hostsAddr.MGC-DRW-GUC01.ipv4}" = ["MGC-DRW-GUC01"];
        "${vars.networking.hostsAddr.MGC-DRW-HDS01.ipv4}" = ["MGC-DRW-HDS01"];
        "${vars.networking.hostsAddr.MGC-DRW-HVS01.ipv4}" = ["MGC-DRW-HVS01"];
        "${vars.networking.hostsAddr.MGC-DRW-PWS01.ipv4}" = ["MGC-DRW-PWS01"];
        "${vars.networking.hostsAddr.MGC-DRW-RST01.ipv4}" = ["MGC-DRW-RST01"];
        "${vars.networking.hostsAddr.MGC-DRW-RVP01.ipv4}" = ["MGC-DRW-RVP01"];
        "192.168.1.99" = ["MGC-DRW-FRW01"];
      };

      megacorp = {
        config = {
          system.hostname = "MGC-DRW-BST01";
          users.admin-user = "${vars.adminUser}";
          bootloader.efi.enable = true;

          networking.static-ip = {
            enable = true;
            ipv4 = "${vars.networking.hostsAddr.MGC-DRW-BST01.ipv4}";
            gateway = "${vars.networking.defaultGateway}";
            nameservers = ["127.0.0.1" "::1"];
            lan-domain = "${vars.networking.internalDomain}";
          };
        };

        services = {
          controller = {
            agent.enable = true;
            server.public-key = vars.authorizedDeployPubKeys;
          };

          dnsmasq.enable = true;

          sshd = {
            bastion = {
              enable = true;
              logo = true;
            };

            authorized-ssh-keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhKBbO3gu8cbKQYOopVAA9gkSHHChkjMYPgfW2NIBrN MGC-LT01"
            ];
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
