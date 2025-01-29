{vars}: {
  megacorp.services.restic.backups = {
    enable = true;
    target-host = "MGC-DRW-RST01";
    target-folders = [
      "/data/file-browser"
    ];
  };

  services = {
    openssh.knownHosts = vars.keys.knownHosts;
  };
}
