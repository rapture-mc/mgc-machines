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

      networking.hostName = "MGC-LT02";

      system.stateVersion = "24.05";

      megacorp = {
        config = {
          users.regular-user.enable = true;

          desktop.enable = true;
        };

        virtualisation.whonix.enable = true;
      };
    }
  ];
}
