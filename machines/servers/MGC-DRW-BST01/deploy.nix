{
  self,
  deploy-rs,
  vars,
  ...
}: {
  hostname = "${vars.networking.hostsAddr.MGC-DRW-BST01.ipv4}";
  profiles.system = {
    sshUser = "controller";
    user = "root";
    path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.MGC-DRW-BST01;
    sshOpts = ["-i" "/var/lib/gitea-runner/default/.ssh/id_ed25519"];
    remoteBuild = true;
  };
}