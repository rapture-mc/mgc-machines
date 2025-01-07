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

      environment.systemPackages = with nixpkgs.legacyPackages.x86_64-linux; [
        go
        gnucash
        pass
      ];

      # Ensures nixos-rebuild doesn't fail when acme certs fail to renew
      systemd.services.acme-localhost.serviceConfig = { SuccessExitStatus = 10; };

      megacorp = {
        config = {
          system.hostname = "MGC-LT01";

          users.admin-user = "${vars.adminUser}";

          bootloader.efi.enable = true;

          desktop.enable = true;
        };

        services = {
          rebuild-machine.enable = true;

          semaphore = {
            enable = true;
            fqdn = "localhost";
          };
        };

        virtualisation.whonix.enable = true;
      };
    }
  ];
}
