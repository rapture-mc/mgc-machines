{vars}: {
  megacorp.services.restic.backups = {
    enable = true;
    target-host = "${vars.networking.hostsAddr.MGC-RST-01.ipv4}";
  };

  services = {
    openssh.knownHosts = vars.knownHosts;
  };
}
