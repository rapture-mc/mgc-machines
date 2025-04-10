{vars, ...}: {
  terraform.required_providers.libvirt.source = "dmacvicar/libvirt";

  provider.libvirt.uri = "qemu:///system";

  module = {
    reverse-proxy = {
      source = "${vars.terraformModuleSource}";
      vm_hostname_prefix = "MGC-DRW-RVP";
      autostart = true;
      vm_count = 1;
      memory = "4096";
      vcpu = 2;
      system_volume = 300;
      bridge = "br0";
      dhcp = true;
    };
  };
}
