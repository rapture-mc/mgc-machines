let
  source = "git::https://gitea.megacorp.industries/megacorp/terraform-libvirt-module.git";
in {
  terraform.required_providers.libvirt.source = "dmacvicar/libvirt";

  provider.libvirt.uri = "qemu+ssh://deploy@mgc-hvs-01/system";

  module = {
    megacorp-grafana-servers = {
      source = "${source}";
      vm_hostname_prefix = "MGC-GRF-";
      autostart = true;
      vm_count = 1;
      memory = "4096";
      vcpu = 2;
      system_volume = 300;
      bridge = "br0";
      dhcp = true;
    };

    megacorp-deploy-servers = {
      index_start = 2;
      source = "${source}";
      vm_hostname_prefix = "MGC-DRS-";
      autostart = true;
      vm_count = 1;
      memory = "6144";
      vcpu = 2;
      system_volume = 300;
      bridge = "br0";
      dhcp = true;
    };
  };
}
