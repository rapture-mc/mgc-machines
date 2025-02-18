{
  # Public keys of wireguard clients/servers
  wireguardPubKeys = {
    MGC-DRW-CTR01 = "Sgq3D3Kn8LDEB+d4/BqTetGZr07JwygYRELiuUNpVDI=";
    MGC-LT01 = "WybmIIlnKoaSpJZVLkw34RwhRhogfTbKXNEchGhrAXE=";
  };

  syncthingIDs = {
    MGC-DRW-CTR01 = "LHBQWNB-OP6DESP-AYQ3MN7-J2UPXDN-UKXWBFT-PQTZKIM-IA3MY3A-M4WL5Q7";
    MGC-DRW-HVS02 = "VGZKTPR-QCDTIDB-2AOG3Q3-XMOEYWT-XOP2GBO-NEMAUKK-ILCDONT-R2USHQJ";
  };

  # The following keys are permitted to connect to the bastion server over SSH
  authorizedBastionPubKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKhKBbO3gu8cbKQYOopVAA9gkSHHChkjMYPgfW2NIBrN benny@MGC-LT01"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICkw50I9jIQ89A9l4E+AiZtZzD+gGoya6u0br3FOxfT6 DWN-STZLR-PC10"
  ];

  # The bastion public key
  bastionPubKey = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzlYmoWjZYFeCNdMBCHBXmqpzK1IBmRiB3hNlsgEtre benny@MGC-DRW-BST01"
  ];

  # The following keys are permitted to connect to remote hosts over SSH to run automated commands
  controllerPubKey = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBDTHyxJfsK8Nb1fJonht3niVbWP2xRR+4ZgqtAMpMw7 benny@MGC-DRW-HVS01"
  ];

  # The following keys are permitted to connect to the Restic server to upload backups
  resticPubKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPtoZpA5PAW7Ofpu2bQt6leqV++raEMX0tH7P6HOgNIT root@MGC-DRW-PWS01"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIF4qf0OthXgzD4gh2PiVpeRkEmAG7R5nKdl1ueypCY/ root@MGC-DRW-FBR01"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINwErc2Z0OV1ngHR04nAS5w0H3lcFisfQZpiDwe3BMFb root@MGC-DRW-BST01"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmPP8QGT8FbY2iJFIgJJH7lVMkIZmeyDJeMf2lwQ+Lw root@MGC-DRW-HVS01"
  ];

  # Hosts whose public SSH key should be trusted when client receives incoming SSH connections
  knownHosts = {
    MGC-DRW-RST01.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIISU8bYvbLOkCv2WXHHgYRTLp4XKAqf6V/yg4rc3yhJB";
  };
}
