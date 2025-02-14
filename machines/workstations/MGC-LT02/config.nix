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
          system = {
            enable = true;
            hostname = "MGC-LT02";
          };

          bootloader = {
            enable = true;
            efi.enable = true;
          };

          users = {
            enable = true;
            regular-user.enable = true;
          };

          desktop.enable = true;
        };

        virtualisation.whonix.enable = true;
      };
    }
  ];
}
