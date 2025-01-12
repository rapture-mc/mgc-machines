{inputs}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../../../sops/secrets/default.yaml;
    defaultSopsFormat = "yaml";
    sshKeyPaths = ["/etc/ssh/ssh_host_rsa_key"];
    secrets.restic-repo-password = {};
  };
}
