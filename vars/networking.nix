{
  defaultGateway = "192.168.1.99";
  nameServers = ["192.168.1.10"];
  internalDomain = "megacorp.industries";

  hostsAddr = {
    MGC-DRW-HDS01 = {
      ipv4 = "192.168.1.30";
    };
    MGC-DRW-PWS01 = {
      ipv4 = "192.168.1.31";
    };
    MGC-DRW-RVP01 = {
      ipv4 = "192.168.1.32";
    };
    MGC-DRW-GUC01 = {
      ipv4 = "192.168.1.33";
    };
    MGC-DRW-CTR01 = {
      ipv4 = "192.168.1.34";
    };
    MGC-DRW-BST01 = {
      ipv4 = "192.168.1.35";
    };
    MGC-DRW-RST01 = {
      ipv4 = "192.168.1.36";
    };
    MGC-DRW-HVS01 = {
      ipv4 = "192.168.1.17";
      int = "eno1";
    };
  };
}
