{
  nixpkgs,
  megacorp,
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

          bootloader.efi.enable = true;

          users.regular-user.enable = true;

          hyprland.enable = true;
        };

        services.rebuild-machine.enable = true;

        virtualisation.whonix.enable = true;
      };
    }
  ];
}
