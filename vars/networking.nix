{
  defaultGateway = "192.168.1.99";
  privateLANSubnet = "192.168.1.0/24";
  nameServers = ["192.168.1.35"];
  internalDomain = "megacorp.industries";
  wireguardPublicIP = "123.243.147.17";

  hostsAddr = {
    MGC-DRW-DMC01 = {
      eth = {
        ipv4 = "192.168.1.5";
      };
    };
    
    MGC-DRW-HVS01 = {
      eth = {
        name = "eno1";
        ipv4 = "192.168.1.17";
      };
    };

    MGC-DRW-HVS02 = {
      eth = {
        name = "eno1";
        ipv4 = "192.168.1.16";
      };
    };

    MGC-DRW-HVS03 = {
      eth = {
        name = "enp6s0";
        ipv4 = "192.168.1.15";
      };
    };

    MGC-DRW-PWS01 = {
      eth = {
        name = "ens3";
        ipv4 = "192.168.1.31";
      };
    };

    MGC-DRW-RVP01 = {
      eth = {
        name = "ens3";
        ipv4 = "192.168.1.32";
      };
    };

    MGC-DRW-GUC01 = {
      eth = {
        name = "ens3";
        ipv4 = "192.168.1.33";
      };
    };

    MGC-DRW-CTR01 = {
      eth = {
        name = "ens3";
        ipv4 = "192.168.1.34";
      };

      wireguard = {
        ipv4 = "10.100.0.1";
      };
    };

    MGC-DRW-BST01 = {
      eth = {
        name = "ens3";
        ipv4 = "192.168.1.35";
      };
    };

    MGC-DRW-RST01 = {
      eth = {
        name = "ens3";
        ipv4 = "192.168.1.36";
      };
    };

    MGC-DRW-FBR01 = {
      eth = {
        name = "ens3";
        ipv4 = "192.168.1.38";
      };
    };

    MGC-DRW-SEM01 = {
      eth = {
        name = "ens3";
        ipv4 = "192.168.1.39";
      };
    };

    MGC-LT01 = {
      wireguard = {
        ipv4 = "10.100.0.2";
      };
    };
  };
}
