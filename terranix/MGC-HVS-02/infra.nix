let
  source = "git::https://gitea.megacorp.industries/megacorp/terraform-libvirt-module.git?ref=942853d0906d3678d368bd31cf15e1d4d201645f";
in {
  terraform.required_providers.libvirt.source = "dmacvicar/libvirt";

  provider.libvirt.uri = "qemu+ssh://deploy@mgc-hvs-02/system";

  module = {
    megacorp-reverse-proxies = {
      source = "${source}";
      vm_hostname_prefix = "MGC-RVP-";
      autostart = true;
      vm_count = 1;
      memory = "4096";
      vcpu = 2;
      system_volume = 300;
      bridge = "br0";
      dhcp = true;
    };

    megacorp-guacamole-servers = {
      source = "${source}";
      vm_hostname_prefix = "MGC-GUC-";
      autostart = true;
      vm_count = 1;
      memory = "4096";
      vcpu = 2;
      system_volume = 300;
      bridge = "br0";
      dhcp = true;
    };

    megacorp-password-servers = {
      source = "${source}";
      vm_hostname_prefix = "MGC-PWS-";
      autostart = true;
      vm_count = 1;
      memory = "4096";
      vcpu = 2;
      system_volume = 300;
      bridge = "br0";
      dhcp = true;
    };

    megacorp-gitea-servers = {
      source = "${source}";
      vm_hostname_prefix = "MGC-GIT-";
      autostart = true;
      vm_count = 1;
      memory = "4096";
      vcpu = 2;
      system_volume = 300;
      bridge = "br0";
      dhcp = true;
    };

    megacorp-restic-servers = {
      source = "${source}";
      vm_hostname_prefix = "MGC-RST-";
      autostart = true;
      vm_count = 1;
      memory = "4096";
      vcpu = 2;
      system_volume = 300;
      bridge = "br0";
      dhcp = true;
    };

    megacorp-nextcloud-servers = {
      source = "${source}";
      vm_hostname_prefix = "MGC-NXC-";
      autostart = true;
      vm_count = 1;
      memory = "4096";
      vcpu = 2;
      system_volume = 300;
      bridge = "br0";
      dhcp = true;
    };

    megacorp-deploy-servers = {
      source = "${source}";
      vm_hostname_prefix = "MGC-DRS-";
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
