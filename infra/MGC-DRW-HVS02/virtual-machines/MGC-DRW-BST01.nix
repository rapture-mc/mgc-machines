{vars, ...}: {
  terraform.required_providers.libvirt.source = "dmacvicar/libvirt";

  provider.libvirt.uri = "qemu+ssh://controller@${vars.networking.hostsAddr.MGC-DRW-HVS02.eth.ipv4}/system";

  module = {
    bastion-server = {
      source = "${vars.terraformModuleSource}";
      vm_hostname_prefix = "MGC-DRW-BST";
      autostart = true;
      vm_count = 1;
      memory = "4096";
      vcpu = 2;
      system_volume = 100;
      bridge = "br0";
      dhcp = true;
    };
  };
}
