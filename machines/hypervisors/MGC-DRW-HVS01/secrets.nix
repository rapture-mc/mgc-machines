{
  inputs,
  vars,
}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../../../sops/secrets/default.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${vars.adminUser}/.config/sops/age/keys.txt";
    secrets.restic-repo-password = {};
    secrets.keycloak-db-password = {};
    secrets.olcRootPW = {
      owner = "openldap";
    };
  };
}
