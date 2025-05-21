{
  nixpkgs,
  megacorp,
  vars,
  inputs,
  pkgs,
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

      networking.hostName = "MGC-DRW-HVS01";

      system.stateVersion = "24.05";

      nixpkgs.config.allowUnfree = true;

      networking.firewall.allowedTCPPorts = [ 389 ];

      services.openldap = {
        enable = true;

        /* enable plain connections only */
        urlList = [ "ldap:///" ];

        settings = {
          attrs = {
            olcLogLevel = "conns config";
          };

          children = {
            "cn=schema".includes = [
              "${pkgs.openldap}/etc/schema/core.ldif"
              "${pkgs.openldap}/etc/schema/cosine.ldif"
              "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
            ];

            "olcDatabase={1}mdb".attrs = {
              objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];

              olcDatabase = "{1}mdb";
              olcDbDirectory = "/var/lib/openldap/data";

              olcSuffix = "dc=megacorp,dc=industries";

              /* your admin account, do not use writeText on a production system */
              olcRootDN = "cn=admin,dc=megacorp,dc=industries";
              olcRootPW.path = pkgs.writeText "olcRootPW" "lolol";

              olcAccess = [
                /* custom access rules for userPassword attributes */
                ''{0}to attrs=userPassword
                    by self write
                    by anonymous auth
                    by * none''

                /* allow read on anything else */
                ''{1}to *
                    by * read''
              ];
            };
          };
        };
      };

      megacorp = {
        config = {
          networking = {
            static-ip = {
              enable = true;
              ipv4 = vars.networking.hostsAddr.MGC-DRW-HVS01.eth.ipv4;
              interface = vars.networking.hostsAddr.MGC-DRW-HVS01.eth.name;
              gateway = vars.networking.defaultGateway;
              nameservers = vars.networking.nameServers;
              lan-domain = vars.networking.internalDomain;
              bridge.enable = true;
            };
          };

          openssh = {
            enable = true;
            authorized-ssh-keys = vars.keys.bastionPubKey;
          };

          desktop = {
            enable = true;
            xrdp = true;
          };

          packages.ninja-cli.enable = true;
        };

        services = {
          controller.server.enable = true;

          comin = {
            enable = true;
            repo = "https://github.com/rapture-mc/mgc-machines";
          };
        };

        virtualisation.hypervisor = {
          enable = true;
          logo = true;
          libvirt-users = [
            "${vars.adminUser}"
          ];
        };
      };
    }
  ];
}
