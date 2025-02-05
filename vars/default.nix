{
  networking = import ./networking.nix;

  keys = import ./keys.nix;

  adminUser = "benny";

  guacamoleFQDN = "guacamole.megacorp.industries";
  nextcloudFQDN = "nextcloud.megacorp.industries";
  file-browserFQDN = "file-browser.megacorp.industries";
  semaphoreFQDN = "semaphore.megacorp.industries";
  grafanaFQDN = "grafana.megacorp.industries";
}
