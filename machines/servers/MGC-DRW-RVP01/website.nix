{ pkgs }: let

website-root = "/var/www/megacorp.industries";

hugo-website = pkgs.stdenv.mkDerivation {
  name = "hugo-website";

  src = pkgs.fetchFromGitHub {
    owner = "rapture-mc";
    repo = "hugo-website";
    rev = "8a14c1cc4b979f6372b3e5b101cfa29600738633";
    hash = "sha256-m5iDWquEPxPemjpS7eyNpelTA955dDjG6YoxlXvka+s=";
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
