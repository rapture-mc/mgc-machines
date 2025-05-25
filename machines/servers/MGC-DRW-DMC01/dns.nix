{ vars, ... }:

{
  networking.hosts = {
    "${vars.networking.hostsAddr.MGC-DRW-DGW01.eth.ipv4}" = ["MGC-DRW-DGW01"];
    "${vars.networking.hostsAddr.MGC-DRW-PWS01.eth.ipv4}" = ["MGC-DRW-PWS01"];
    "${vars.networking.hostsAddr.MGC-DRW-RST01.eth.ipv4}" = ["MGC-DRW-RST01"];
    "${vars.networking.hostsAddr.MGC-DRW-RVP01.eth.ipv4}" = ["MGC-DRW-RVP01"];
    "${vars.networking.hostsAddr.MGC-DRW-HVS01.eth.ipv4}" = ["MGC-DRW-HVS01"];
    "${vars.networking.hostsAddr.MGC-DRW-HVS02.eth.ipv4}" = ["MGC-DRW-HVS02"];
    "${vars.networking.hostsAddr.MGC-DRW-HVS03.eth.ipv4}" = ["MGC-DRW-HVS03"];
    "${vars.networking.hostsAddr.MGC-DRW-DMC01.eth.ipv4}" = ["MGC-DRW-DMC01"];
    "192.168.1.99" = ["MGC-DRW-FRW01"];
  };

  megacorp.services.dnsmasq = {
    enable = true;
    domain = vars.networking.internalDomain;
  };
}
