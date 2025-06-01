{ pkgs }: let

website-root = "/var/www/megacorp.industries";

hugo-website = pkgs.stdenv.mkDerivation {
  name = "hugo-website";

  src = pkgs.fetchFromGitHub {
    owner = "rapture-mc";
    repo = "hugo-website";
    rev = "f594a1b0f7d36073c6be5d251cb78291ad22562e";
    hash = "sha256-Uxu/9mW1PdNeISqXbLSqDSdOxWaWPR1u+Md9pnE5CdQ=";
  };

  installPhase = ''
    mkdir $out

    ${pkgs.hugo}/bin/hugo

    cp -rv public $out
  '';
};
in {
  services.nginx.virtualHosts = {
    "megacorp.industries" = {
      forceSSL = true;
      enableACME = true;
      root = website-root;
    };
  };

  systemd.services.rebuild-website = {
    enable = true;
    description = "Rebuilds hugo website";
    script = ''
      if [ ! -d ${website-root} ]; then
        echo "Website directory doesn't exist, creating..."
        mkdir -p ${website-root}

        echo "Setting permissions on newly created directory..."
        chown nginx:nginx ${website-root}
      fi

      ${pkgs.rsync}/bin/rsync -avz --delete ${hugo-website}/public/ ${website-root}
      chown -R nginx:nginx ${website-root}
    '';
    unitConfig.Before = "nginx.service";
    wantedBy = ["multi-user.target"];
  };
}
