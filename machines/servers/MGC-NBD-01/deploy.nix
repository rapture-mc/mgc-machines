{
  self,
  deploy-rs,
  vars,
  ...
}: {
  hostname = "${vars.networking.hostsAddr.MGC-NBD-01.ipv4}";
  profiles.system = {
    sshUser = "deploy";
    user = "root";
    path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.MGC-NBD-01;
    sshOpts = ["-i" "/var/lib/gitea-runner/default/.ssh/id_ed25519"];
  };
}
