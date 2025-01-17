{importMachineConfig, ...}: {
  # Servers
  MGC-DRW-BST01 = importMachineConfig "servers" "MGC-DRW-BST01" "config";
  MGC-DRW-CTR01 = importMachineConfig "servers" "MGC-DRW-CTR01" "config";
  MGC-DRW-GUC01 = importMachineConfig "servers" "MGC-DRW-GUC01" "config";
  MGC-DRW-FBR01 = importMachineConfig "servers" "MGC-DRW-FBR01" "config";
  MGC-DRW-PWS01 = importMachineConfig "servers" "MGC-DRW-PWS01" "config";
  MGC-DRW-RST01 = importMachineConfig "servers" "MGC-DRW-RST01" "config";
  MGC-DRW-RVP01 = importMachineConfig "servers" "MGC-DRW-RVP01" "config";
  MGC-DRW-SEM01 = importMachineConfig "servers" "MGC-DRW-SEM01" "config";
  MGC-DRW-VPN01 = importMachineConfig "servers" "MGC-DRW-VPN01" "config";

  # Hypervisors
  MGC-DRW-HVS01 = importMachineConfig "hypervisors" "MGC-DRW-HVS01" "config";
  MGC-DRW-HVS02 = importMachineConfig "hypervisors" "MGC-DRW-HVS02" "config";
  MGC-DRW-HVS03 = importMachineConfig "hypervisors" "MGC-DRW-HVS03" "config";

  # Workstations
  MGC-LT01 = importMachineConfig "workstations" "MGC-LT01" "config";
  MGC-LT02 = importMachineConfig "workstations" "MGC-LT02" "config";
}
