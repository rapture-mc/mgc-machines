{vars}: {
  megacorp.services.restic.backups = {
    enable = true;
    target-host = "${vars.networking.hostsAddr.MGC-RST-01.ipv4}";
  };

  services = {
    openssh.knownHosts = vars.knownHosts;

    restic.backups.nextcloud = {
      initialize = true;
      user = "root";
      passwordFile = "/run/secrets/restic-repo-password";
      paths = ["/var/lib/nextcloud-backup"];
      repository = "sftp:restic-backup@MGC-RST-01:/var/lib/restic-backup/nextcloud";
      timerConfig = {
        persistent = true;
        OnCalendar = "Sat *-*-* 00:00";
      };
    };
  };
}
