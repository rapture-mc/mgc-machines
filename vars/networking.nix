{
  defaultGateway = "192.168.1.99";
  nameServers = ["192.168.1.10"];
  internalDomain = "megacorp.industries";

  hostsAddr = {
    MGC-DRW-DC01 = {
      ipv4 = "192.168.1.5";
    };
    MGC-BST-01 = {
      ipv4 = "192.168.1.10";
    };
    MGC-DRW-BH02 = {
      ipv4 = "192.168.1.11";
    };
    MGC-HVS-01 = {
      ipv4 = "192.168.1.15";
      int = "enp6s0";
    };
    MGC-HVS-02 = {
      ipv4 = "192.168.1.16";
      int = "eno1";
    };
    MGC-HVS-03 = {
      ipv4 = "192.168.1.17";
      int = "eno1";
    };
    MGC-NBD-01 = {
      ipv4 = "192.168.1.19";
      int = "eno1";
    };
    MGC-PWS-01 = {
      ipv4 = "192.168.1.20";
    };
    MGC-DRS-01 = {
      ipv4 = "192.168.1.25";
      int = "end0";
    };
    MGC-DRS-02 = {
      ipv4 = "192.168.1.26";
    };
    MGC-RST-01 = {
      ipv4 = "192.168.1.49";
    };
    MGC-RVP-01 = {
      ipv4 = "192.168.1.50";
    };
    MGC-GIT-01 = {
      ipv4 = "192.168.1.51";
    };
    MGC-GUC-01 = {
      ipv4 = "192.168.1.52";
    };
    MGC-GRF-01 = {
      ipv4 = "192.168.1.53";
    };
    MGC-NXC-01 = {
      ipv4 = "192.168.1.54";
    };
    MGC-K3M-01 = {
      ipv4 = "192.168.1.70";
    };
    MGC-K3S-01 = {
      ipv4 = "192.168.1.73";
    };
    MGC-K3S-02 = {
      ipv4 = "192.168.1.74";
    };
    MGC-DT-01 = {
      ipv4 = "192.168.1.101";
    };
  };
}
