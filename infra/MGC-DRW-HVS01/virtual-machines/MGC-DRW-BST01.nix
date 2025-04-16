{vars, ...}: {
  terraform.required_providers.libvirt.source = "dmacvicar/libvirt";

  provider.libvirt.uri = "qemu:///system";

  module = {
    bastion-server = {
      source = "${vars.terraformModuleSource}";
      vm_hostname_prefix = "MGC-DRW-BST";
      autostart = true;
      vm_count = 1;
      memory = "4096";
      vcpu = 2;
      system_volume = 100;
      firmware = "/home/benny/Dev/result-fd/FV/OVMF_CODE.fd";
      bridge = "br0";
      dhcp = true;
    };
  };
}
