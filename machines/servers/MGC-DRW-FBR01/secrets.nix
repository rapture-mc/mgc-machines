{inputs}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../../../sops/secrets/default.yaml;
    defaultSopsFormat = "yaml";
    gnupg.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets.restic-repo-password = {};
    secrets.grub-admin-password = {};
  };
}
