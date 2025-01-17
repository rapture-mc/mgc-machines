{inputs}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../../../sops/secrets/default.yaml;
    defaultSopsFormat = "yaml";
    sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets.postgres-password = {};
    secrets.semaphore-db-pass = {};
    secrets.semaphore-access-key-encryption = {};
  };
}
