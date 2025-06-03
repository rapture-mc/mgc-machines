{pkgs}: let
  website-root = "/var/www/megacorp.industries";

  hugo-website = pkgs.stdenv.mkDerivation {
    name = "hugo-website";

    src = pkgs.fetchFromGitHub {
      owner = "rapture-mc";
      repo = "hugo-website";
      rev = "bdaa632f6f27587fcee26f9ea80f85a0a34d250a";
      hash = "sha256-BXl1LKBs9iLsSUMYZijGP5+HUT0RyLyiLz3ib9i+cn8=";
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
