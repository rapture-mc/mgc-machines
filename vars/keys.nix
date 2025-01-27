{
  # Public keys of wireguard clients/servers
  wireguardPubKeys = {
    MGC-DRW-CTR01 = "Sgq3D3Kn8LDEB+d4/BqTetGZr07JwygYRELiuUNpVDI=";
    MGC-LT01 = "WybmIIlnKoaSpJZVLkw34RwhRhogfTbKXNEchGhrAXE=";
  };

  # The following keys are permitted to connect to the bastion server over SSH
  bastionPubKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhKBbO3gu8cbKQYOopVAA9gkSHHChkjMYPgfW2NIBrN benny@MGC-LT01"
  ];

  # The following keys are permitted to connect to remote hosts over SSH to run automated commands through deploy-rs
  deployPubKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBNHs6Q37Kt8G1aA0R610uRBPmhMrD/MwH9DB7aEyQ0E benny@MGC-DRW-CTR01"
  ];

  # The following keys are permitted to connect to the Restic server to upload backups
  resticPubKeys = [

  ];

  # Hosts whose public ssh key should be known always and trusted when connecting over SSH
  knownHosts = {
    MGC-RST-01.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTd28ULgwqVMQZD44EUFzneJr1GDwzzsi0NF2qgLNAH";
  };
}
