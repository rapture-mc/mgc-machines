let
  source = "git::https://gitea.megacorp.industries/megacorp/terraform-libvirt-module.git?ref=40acff807a0ffb1c0da741774c37ebeda90730b7";
in {
  terraform.required_providers.libvirt.source = "dmacvicar/libvirt";

  provider.libvirt.uri = "qemu+ssh://deploy@mgc-hvs-03/system";

  module = {
    megacorp-netbird-servers = {
      source = "${source}";
      vm_hostname_prefix = "MGC-NBD-";
      autostart = true;
      vm_count = 1;
      memory = "4096";
      vcpu = 2;
      system_volume = 300;
      bridge = "br0";
      dhcp = true;
    };

    megacorp-domain-controllers = {
      os_img_url = "/var/lib/libvirt/images/packer-win2022";
      uefi_enabled = false;
      source = "${source}";
      vm_hostname_prefix = "MGC-DRW-DC";
      autostart = true;
      vm_count = 1;
      memory = "4096";
      vcpu = 2;
      system_volume = 300;
      bridge = "br0";
      dhcp = true;
    };

    megacorp-bastion-hosts = {
      source = "${source}";
      index_start = 2;
      vm_hostname_prefix = "MGC-DRW-BH";
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
