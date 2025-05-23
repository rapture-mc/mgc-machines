{
  nixpkgs,
  megacorp,
  vars,
  ...
}:
nixpkgs.lib.nixosSystem {
  modules = [
    megacorp.nixosModules.default
    {
      imports = [
        (import ../../base-config.nix {inherit vars;})
        ./hardware-config.nix
      ];

      nixpkgs.config.allowUnfree = true;

      networking.hostName = "MGC-DRW-HVS02";

      system.stateVersion = "24.05";

      # The Ethernet card will suddenly stop working if too much data is transmitted over the link at one time. See https://www.reddit.com/r/Proxmox/comments/1drs89s/intel_nic_e1000e_hardware_unit_hang/?rdt=43359 for more info.
      systemd.services.fix-ethernet-bug = {
        enable = true;
        description = "This service provides a dirty hack to fix the Ethernet card on the Intel NUC (NUC10i5FNK).";
        serviceConfig.ExecStart = "${nixpkgs.legacyPackages.x86_64-linux.ethtool}/bin/ethtool -K ${vars.networking.hostsAddr.MGC-DRW-HVS02.eth.name} tso off gso off";
        unitConfig.After = "network-online.target";
        wantedBy = ["multi-user.target"];
      };

      # Extra stuff
      environment.systemPackages = with nixpkgs.legacyPackages.x86_64-linux; [
        hugo
        gimp
        sioyek
      ];

      networking.firewall.allowedTCPPorts = [80];

      services.nginx = {
        enable = true;
        virtualHosts."megacorp.industries" = {
          root = "/var/www/megacorp.industries";
        };
      };

      megacorp = {
        config = {
          networking = {
            static-ip = {
              enable = true;
              ipv4 = vars.networking.hostsAddr.MGC-DRW-HVS02.eth.ipv4;
              interface = vars.networking.hostsAddr.MGC-DRW-HVS02.eth.name;
              gateway = vars.networking.defaultGateway;
              nameservers = vars.networking.nameServers;
              lan-domain = vars.networking.internalDomain;
              bridge.enable = true;
            };
          };

          openssh = {
            enable = true;
            authorized-ssh-keys = vars.keys.bastionPubKey ++ ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBDTHyxJfsK8Nb1fJonht3niVbWP2xRR+4ZgqtAMpMw7 benny@MGC-DRW-HVS01"];
          };

          desktop = {
            enable = true;
            xrdp = true;
          };
        };

        services = {
          controller = {
            agent.enable = true;
            server.public-key = vars.keys.controllerPubKey;
          };

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
            "controller"
          ];
        };
      };
    }
  ];
}
