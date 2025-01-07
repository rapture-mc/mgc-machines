{importMachineConfig, ...}: {
  # Servers
  MGC-DRW-BST01 = importMachineConfig "servers" "MGC-DRW-BST01" "deploy";
  MGC-DRW-GUC01 = importMachineConfig "servers" "MGC-DRW-GUC01" "deploy";
  MGC-DRW-HDS01 = importMachineConfig "servers" "MGC-DRW-HDS01" "deploy";
  MGC-DRW-PWS01 = importMachineConfig "servers" "MGC-DRW-PWS01" "deploy";
  MGC-DRW-RST01 = importMachineConfig "servers" "MGC-DRW-RST01" "deploy";
  MGC-DRW-RVP01 = importMachineConfig "servers" "MGC-DRW-RVP01" "deploy";

  # Hypervisors
  MGC-DRW-HVS01 = importMachineConfig "hypervisors" "MGC-DRW-HVS01" "deploy";
}
