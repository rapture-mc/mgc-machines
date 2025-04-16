{vars, ...}: {
  terraform.required_providers.libvirt.source = "dmacvicar/libvirt";

  provider.libvirt.uri = "qemu:///system";

  module = {
    password-server = {
      source = "${vars.terraformModuleSource}";
      vm_hostname_prefix = "MGC-DRW-PWS";
      autostart = true;
      vm_count = 1;
      firmware = "/nix/store/p1ycdgz9w30qw0qppk2jkjcx19360gdg-qemu-ovmf/FV/OVMF_CODE.fd";
      memory = "4096";
      vcpu = 2;
      system_volume = 300;
      bridge = "br0";
      dhcp = true;
    };
  };
}
