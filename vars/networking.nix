{
  defaultGateway = "192.168.1.99";
  nameServers = ["192.168.1.35"];
  wireguardSubnet = "10.100.0.0/24";
  internalDomain = "megacorp.industries";

  hostsAddr = {
    MGC-DRW-VPN01 = {
      eth = {
        ipv4 = "192.168.1.30";
        name = "ens3";
      };
      wireguard = {
        ipv4 = "10.100.0.1";
        name = "wg0";
      };
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
    MGC-DRW-NXC01 = {
      ipv4 = "192.168.1.37";
    };
    MGC-DRW-FBR01 = {
      ipv4 = "192.168.1.38";
    };
    MGC-DRW-SEM01 = {
      ipv4 = "192.168.1.39";
    };
    MGC-DRW-HVS01 = {
      ipv4 = "192.168.1.17";
      int = "eno1";
    };
    MGC-DRW-HVS02 = {
      ipv4 = "192.168.1.16";
      int = "eno1";
    };
    MGC-DRW-HVS03 = {
      ipv4 = "192.168.1.15";
      int = "enp6s0";
    };
  };
}
