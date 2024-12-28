{importMachineConfig, ...}: {
  # Servers
  MGC-BST-01 = importMachineConfig "servers" "MGC-BST-01" "config";
  MGC-DRS-01 = importMachineConfig "servers" "MGC-DRS-01" "config";
  MGC-DRS-02 = importMachineConfig "servers" "MGC-DRS-02" "config";
  MGC-DRW-BH02 = importMachineConfig "servers" "MGC-DRW-BH02" "config";
  MGC-GIT-01 = importMachineConfig "servers" "MGC-GIT-01" "config";
  MGC-GRF-01 = importMachineConfig "servers" "MGC-GRF-01" "config";
  MGC-GUC-01 = importMachineConfig "servers" "MGC-GUC-01" "config";
  MGC-NBD-01 = importMachineConfig "servers" "MGC-NBD-01" "config";
  MGC-NXC-01 = importMachineConfig "servers" "MGC-NXC-01" "config";
  MGC-PWS-01 = importMachineConfig "servers" "MGC-PWS-01" "config";
  MGC-RST-01 = importMachineConfig "servers" "MGC-RST-01" "config";
  MGC-RVP-01 = importMachineConfig "servers" "MGC-RVP-01" "config";

  # Hypervisors
  MGC-HVS-01 = importMachineConfig "hypervisors" "MGC-HVS-01" "config";
  MGC-HVS-02 = importMachineConfig "hypervisors" "MGC-HVS-02" "config";
  MGC-HVS-03 = importMachineConfig "hypervisors" "MGC-HVS-03" "config";

  # Workstations
  MGC-LT01 = importMachineConfig "workstations" "MGC-LT01" "config";
  MGC-LT02 = importMachineConfig "workstations" "MGC-LT02" "config";
}
