{
  nixpkgs,
  megacorp,
  vars,
  nixos-hardware,
  ...
}: let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
nixpkgs.lib.nixosSystem {
  modules = [
    megacorp.nixosModules.default
    nixos-hardware.nixosModules.lenovo-thinkpad-x13
    {
      imports = [
        (import ../../base-config.nix {inherit vars;})
        ./hardware-config.nix
      ];

      # users = {
      #   mutableUsers = false;
      #   users.test-user = {
      #     isNormalUser = true;
      #     hashedPassword = "$6$Ey6fzsEaGSkk2286$cUtsv6HcBfo1GRxwEZbVOT23zOT9rOU9XumC14pprvmiiagkQWmxKqYbjTIsAt.d8wPS1NdYas0Dv4khDxG/G0";
      #   };
      # };

      networking.hostName = "MGC-LT01";

      system.stateVersion = "24.05";

      environment.systemPackages = with pkgs; [
        hugo
        gnucash
        hledger
        spotify
        sioyek
      ];

      virtualisation.docker.enable = true;

      megacorp = {
        config = {
          openssh = {
            enable = true;
            authorized-ssh-keys = vars.keys.bastionPubKey;
          };

          desktop = {
            enable = true;
            display-manager = "sddm";
            desktop-manager = "plasma6";
          };
        };

        services = {
          controller = {
            agent.enable = true;
            server.public-key = vars.keys.controllerPubKey;
          };

          wireguard-client = {
            enable = true;
            ipv4 = vars.networking.hostsAddr.MGC-LT01.wireguard.ipv4;
            allowed-ips = ["${vars.networking.privateLANSubnet}"];
            server = {
              ipv4 = vars.networking.wireguardPublicIP;
              public-key = vars.keys.wireguardPubKeys.MGC-DRW-CTR01;
            };
          };

          comin = {
            enable = true;
            repo = "https://github.com/rapture-mc/mgc-machines";
          };

          password-store.enable = true;
        };

        virtualisation.whonix.enable = true;
      };
    }
  ];
}
