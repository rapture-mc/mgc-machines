{vars}: {
  megacorp.services.restic.backups = {
    enable = true;
    target-host = "MGC-DRW-RST01";
    target-folders = [
      "/home/${vars.adminUser}/.gnupg"
      "/home/${vars.adminUser}/.password-store"
    ];
  };

  services = {
    openssh.knownHosts = vars.keys.knownHosts;
  };
}
