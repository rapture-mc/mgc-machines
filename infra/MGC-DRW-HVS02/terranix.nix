{
  pkgs,
  terranix,
  system,
  machineName,
  action,
  vars,
  ...
}: let
  opentofu = pkgs.opentofu;
  terraformConfiguration = terranix.lib.terranixConfiguration {
    inherit system;
    modules = [
      (import ./virtual-machines/MGC-DRW-BST01.nix {inherit vars;})
      (import ./virtual-machines/MGC-DRW-PWS01.nix {inherit vars;})
      (import ./virtual-machines/MGC-DRW-RST01.nix {inherit vars;})
    ];
  };
in {
  type = "app";
  program = toString (pkgs.writers.writeBash "apply" ''
    cd ./infra/${machineName}

    if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
    cp ${terraformConfiguration} config.tf.json \
      && ${opentofu}/bin/tofu init \
      && ${opentofu}/bin/tofu ${action}
  '');
}
