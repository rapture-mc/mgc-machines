{
  self,
  deploy-rs,
  vars,
  ...
}: {
  hostname = "${vars.networking.hostsAddr.MGC-BST-01.ipv4}";
  profiles.system = {
    sshUser = "deploy";
    user = "root";
    path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.MGC-BST-01;
    sshOpts = ["-i" "/var/lib/gitea-runner/default/.ssh/id_ed25519"];
    remoteBuild = true;
  };
}
