{
  nixpkgs,
  pkgs,
  megacorp,
  vars,
  terranix,
  system,
  ...
}: let
  lib = nixpkgs.lib;
in
  nixpkgs.lib.nixosSystem {
    modules = [
      megacorp.nixosModules.default
      {
        imports = [
          (import ../../base-config.nix {inherit vars;})
          (import ./infra.nix {inherit pkgs vars terranix system;})
          ./hardware-config.nix
        ];

        nixpkgs.config.allowUnfree = true;

        networking.hostName = "MGC-DRW-HVS03";

        system.stateVersion = "24.05";

        megacorp = {
          config = {
            openssh = {
              enable = true;
              authorized-ssh-keys = vars.keys.bastionPubKey;
            };

            bootloader.efi.enable = lib.mkForce false;

            networking = {
              static-ip = {
                enable = true;
                ipv4 = vars.networking.hostsAddr.MGC-DRW-HVS03.eth.ipv4;
                interface = vars.networking.hostsAddr.MGC-DRW-HVS03.eth.name;
                gateway = vars.networking.defaultGateway;
                nameservers = vars.networking.nameServers;
                lan-domain = vars.networking.internalDomain;
                bridge.enable = true;
              };
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
