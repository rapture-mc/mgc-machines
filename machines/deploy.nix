{importMachineConfig, ...}: {
  # Servers
  MGC-DRW-BST01 = importMachineConfig "servers" "MGC-DRW-BST01" "deploy";
  MGC-DRW-GUC01 = importMachineConfig "servers" "MGC-DRW-GUC01" "deploy";
  MGC-DRW-NXC01 = importMachineConfig "servers" "MGC-DRW-NXC01" "deploy";
  MGC-DRW-PWS01 = importMachineConfig "servers" "MGC-DRW-PWS01" "deploy";
  MGC-DRW-RST01 = importMachineConfig "servers" "MGC-DRW-RST01" "deploy";
  MGC-DRW-RVP01 = importMachineConfig "servers" "MGC-DRW-RVP01" "deploy";
  MGC-DRW-VPN01 = importMachineConfig "servers" "MGC-DRW-VPN01" "deploy";

  # Hypervisors
  MGC-DRW-HVS01 = importMachineConfig "hypervisors" "MGC-DRW-HVS01" "deploy";
  MGC-DRW-HVS02 = importMachineConfig "hypervisors" "MGC-DRW-HVS02" "deploy";
  MGC-DRW-HVS03 = importMachineConfig "hypervisors" "MGC-DRW-HVS03" "deploy";
}
