{importMachineConfig, ...}: {
  # Servers
  MGC-DRW-BST01 = importMachineConfig "servers" "MGC-DRW-BST01" "config";
  MGC-DRW-CTR01 = importMachineConfig "servers" "MGC-DRW-CTR01" "config";
  MGC-DRW-GUC01 = importMachineConfig "servers" "MGC-DRW-GUC01" "config";
  MGC-DRW-HDS01 = importMachineConfig "servers" "MGC-DRW-HDS01" "config";
  MGC-DRW-PWS01 = importMachineConfig "servers" "MGC-DRW-PWS01" "config";
  MGC-DRW-RST01 = importMachineConfig "servers" "MGC-DRW-RST01" "config";
  MGC-DRW-RVP01 = importMachineConfig "servers" "MGC-DRW-RVP01" "config";

  # Hypervisors
  MGC-DRW-HVS01 = importMachineConfig "hypervisors" "MGC-DRW-HVS01" "config";

  # Workstations
  MGC-LT01 = importMachineConfig "workstations" "MGC-LT01" "config";
  MGC-LT02 = importMachineConfig "workstations" "MGC-LT02" "config";
}
