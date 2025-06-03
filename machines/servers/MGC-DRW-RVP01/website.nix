{pkgs}: let
  website-root = "/var/www/megacorp.industries";

  hugo-website = pkgs.stdenv.mkDerivation {
    name = "hugo-website";

    src = pkgs.fetchFromGitHub {
      owner = "rapture-mc";
      repo = "hugo-website";
      rev = "6e9c2caefeb860f4736e89021e9f24b1cfe5b286";
      hash = "sha256-SZUJG8d7deg+Uj+8DY1FyZ+fpNZVGIIZ7KYuc4eCQLc=";
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
      extraConfig = ''
        error_page 404 /404.html;
      '';
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
