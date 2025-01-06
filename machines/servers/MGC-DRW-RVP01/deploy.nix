{
  self,
  deploy-rs,
  vars,
  ...
}: {
  hostname = "${vars.networking.hostsAddr.MGC-RVP-01.ipv4}";
  profiles.system = {
    sshUser = "controller";
    user = "root";
    path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.MGC-RVP-01;
    remoteBuild = true;
  };
}
