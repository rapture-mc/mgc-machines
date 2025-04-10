{inputs, vars}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../../../sops/secrets/default.yaml;
    defaultSopsFormat = "yaml";
    gnupg.sshKeyPaths = ["/home/${vars.adminUser}/.config/sops/age/keys.txt"];
    secrets.restic-repo-password = {};
  };
}
