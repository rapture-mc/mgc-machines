{
  networking = import ./networking.nix;

  adminUser = "benny";

  guacamoleFQDN = "guacamole.megacorp.industries";

  # The following keys are permitted to connect to remote hosts over SSH to run deploy-rs
  authorizedDeployPubKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOT7JnanXvRKEuOkLzU3Suw/7KFAqUtlbUngDuCM6eXR benny@MGC-DRS-01"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwT0RrqTnNKxuPTVIYTXlgUlsIAqf4TMVmpYf5IfnbK gitea-runner@MGC-DRS-01"
  ];

  # The following keys are permitted to connect to the Restic server to upload backups
  authorizedResticPubKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICaBIldQpbmMS6EtRh3Weu3JaocZhnuHbhph5W+BXDei root@MGC-GIT-01"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTWjC0cbXGZHhx9vd1WH8uetNS66OwlYSVuoCfbq5De root@MGC-DRS-02"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEaXzeWVqu61BxBd9JMtF7BccENmJAAonMjHD2uVBnXN root@MGC-BST-01"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvSsr6yFND8gYfHOBxyzqNHhzHpCAw5o9l/cquhrgXL root@MGC-NXC-01"
  ];

  # Hosts whose public ssh key should be known always and trusted when connecting over SSH
  knownHosts = {
    MGC-RST-01.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTd28ULgwqVMQZD44EUFzneJr1GDwzzsi0NF2qgLNAH";
  };
}
