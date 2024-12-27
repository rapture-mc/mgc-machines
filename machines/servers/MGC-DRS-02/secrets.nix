{inputs}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../../../sops/secrets/default.yaml;
    defaultSopsFormat = "yaml";
    sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets = {
      restic-repo-password = {};
      gitea-token.mode = "0444";
    };
  };
}
