{importMachineConfig, ...}: {
  # Servers
  MGC-BST-01 = importMachineConfig "servers" "MGC-BST-01" "deploy";
  MGC-DRW-BH02 = importMachineConfig "servers" "MGC-DRW-BH02" "deploy";
  MGC-GIT-01 = importMachineConfig "servers" "MGC-GIT-01" "deploy";
  MGC-GRF-01 = importMachineConfig "servers" "MGC-GRF-01" "deploy";
  MGC-GUC-01 = importMachineConfig "servers" "MGC-GUC-01" "deploy";
  MGC-NBD-01 = importMachineConfig "servers" "MGC-NBD-01" "deploy";
  MGC-NXC-01 = importMachineConfig "servers" "MGC-NXC-01" "deploy";
  MGC-PWS-01 = importMachineConfig "servers" "MGC-PWS-01" "deploy";
  MGC-RST-01 = importMachineConfig "servers" "MGC-RST-01" "deploy";
  MGC-RVP-01 = importMachineConfig "servers" "MGC-RVP-01" "deploy";

  # Hypervisors
  MGC-HVS-01 = importMachineConfig "hypervisors" "MGC-HVS-01" "deploy";
  MGC-HVS-02 = importMachineConfig "hypervisors" "MGC-HVS-02" "deploy";
  MGC-HVS-03 = importMachineConfig "hypervisors" "MGC-HVS-03" "deploy";
}
