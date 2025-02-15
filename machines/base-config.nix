{vars, ...}: {
  megacorp = {
    config = {
      system.enable = true;

      bootloader = {
        enable = true;
        efi.enable = true;
      };

      users = {
        enable = true;
        admin-user = vars.adminUser;
        shell = "nushell";
      };

      nixvim.enable = true;
      packages.enable = true;
    };

    services = {
      prometheus = {
        enable = true;
        node-exporter.enable = true;
      };
    };
  };
}
