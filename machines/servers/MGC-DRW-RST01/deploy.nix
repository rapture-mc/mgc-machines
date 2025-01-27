{
  self,
  deploy-rs,
  vars,
  ...
}: {
  hostname = vars.networking.hostsAddr.MGC-DRW-RST01.eth.ipv4;
  profiles.system = {
    sshUser = "controller";
    user = "root";
    path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.MGC-DRW-RST01;
    remoteBuild = true;
  };
}
