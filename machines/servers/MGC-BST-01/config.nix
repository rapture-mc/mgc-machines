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
        "${vars.networking.hostsAddr.MGC-DRW-DC01.ipv4}" = ["mgc-drw-dc01"];
        "${vars.networking.hostsAddr.MGC-HVS-01.ipv4}" = ["mgc-hvs-01"];
        "${vars.networking.hostsAddr.MGC-HVS-02.ipv4}" = ["mgc-hvs-02"];
        "${vars.networking.hostsAddr.MGC-HVS-03.ipv4}" = ["mgc-hvs-03"];
        "${vars.networking.hostsAddr.MGC-NBD-01.ipv4}" = ["mgc-nbd-01"];
        "${vars.networking.hostsAddr.MGC-PWS-01.ipv4}" = ["mgc-pws-01"];
        "${vars.networking.hostsAddr.MGC-DRS-01.ipv4}" = ["mgc-drs-01"];
        "${vars.networking.hostsAddr.MGC-DRS-02.ipv4}" = ["mgc-drs-02"];
        "${vars.networking.hostsAddr.MGC-RST-01.ipv4}" = ["mgc-rst-01"];
        "${vars.networking.hostsAddr.MGC-RVP-01.ipv4}" = ["mgc-rvp-01"];
        "${vars.networking.hostsAddr.MGC-GIT-01.ipv4}" = ["mgc-git-01"];
        "${vars.networking.hostsAddr.MGC-GUC-01.ipv4}" = ["mgc-guc-01"];
        "${vars.networking.hostsAddr.MGC-GRF-01.ipv4}" = ["mgc-grf-01"];
        "${vars.networking.hostsAddr.MGC-NXC-01.ipv4}" = ["mgc-nxc-01"];
        "192.168.1.99" = ["mgc-fw-01"];
      };

      megacorp = {
        config = {
          system.hostname = "MGC-BST-01";
          users.admin-user = "${vars.adminUser}";
          bootloader.type = "extlinux";

          networking.static-ip = {
            enable = true;
            ipv4 = "${vars.networking.hostsAddr.MGC-BST-01.ipv4}";
            gateway = "${vars.networking.defaultGateway}";
            nameservers = ["127.0.0.1" "::1"];
            lan-domain = "${vars.networking.internalDomain}";
          };
        };

        services = {
          deploy-rs = {
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
