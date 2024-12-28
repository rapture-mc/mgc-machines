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
        ./hardware-config.nix
      ];

      megacorp = {
        config = {
          system.hostname = "MGC-LT02";

          users.admin-user = "${vars.adminUser}";

          bootloader.efi.enable = true;

          desktop.enable = true;
        };

        services.rebuild-machine.enable = true;

        # virtualisation.whonix.enable = true;
      };
    }
  ];
}
