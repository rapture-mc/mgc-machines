{
  self,
  deploy-rs,
  vars,
  ...
}: {
  hostname = "${vars.networking.hostsAddr.MGC-HVS-03.ipv4}";
  profiles.system = {
    sshUser = "deploy";
    user = "root";
    path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.MGC-HVS-03;
    sshOpts = ["-i" "/var/lib/gitea-runner/default/.ssh/id_ed25519"];
    remoteBuild = true;
  };
}
