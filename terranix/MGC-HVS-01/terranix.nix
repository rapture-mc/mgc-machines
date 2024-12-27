{
  pkgs,
  terranix,
  system,
  machineName,
  action,
  ...
}: let
  opentofu = pkgs.opentofu;
  terraformConfiguration = terranix.lib.terranixConfiguration {
    inherit system;
    modules = [./infra.nix];
  };
in {
  type = "app";
  program = toString (pkgs.writers.writeBash "apply" ''
    cd ./terranix/${machineName}

    if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
    cp ${terraformConfiguration} config.tf.json \
      && ${opentofu}/bin/tofu init \
      && ${opentofu}/bin/tofu ${action}
  '');
}
