{pkgs}: let
  hugo-website-root = "/var/www/megacorp.industries";

  about-website-root = "/var/www/cv.megacorp.industries";

  hugo-website = pkgs.stdenv.mkDerivation {
    name = "hugo-website";

    src = pkgs.fetchFromGitHub {
      owner = "rapture-mc";
      repo = "hugo-website";
      rev = "1541ab82434fcff25501cdf7b9151ad0f9a7c5db";
      hash = "sha256-aMxz28mFker1EfMydc7rlsqT7yzJq7zYgptaCL2oboY=";
    };

    installPhase = ''
      mkdir $out

      ${pkgs.hugo}/bin/hugo

      cp -rv public $out
    '';
  };

  about-website = pkgs.stdenv.mkDerivation {
    name = "about-website";

    src = pkgs.fetchFromGitHub {
      owner = "rapture-mc";
      repo = "hugo-terminal";
      rev = "fe9d1cbc033f0fc14e554f9e437ce1f03560d511";
      hash = "sha256-u4ab3eYSlBwRevOohCZ5w2LB3JWXnST+khMPikcCK2U=";
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
      root = hugo-website-root;
      extraConfig = ''
        error_page 404 /404.html;
      '';
    };

    "cv.megacorp.industries" = {
      forceSSL = true;
      enableACME = true;
      root = about-website-root;
    };
  };

  systemd.services = {
    rebuild-hugo-website = {
      enable = true;
      description = "Rebuilds hugo website";
      script = ''
        if [ ! -d ${hugo-website-root} ]; then
          echo "Website directory doesn't exist, creating..."
          mkdir -p ${hugo-website-root}

          echo "Setting permissions on newly created directory..."
          chown nginx:nginx ${hugo-website-root}
        fi

        ${pkgs.rsync}/bin/rsync -avz --delete ${hugo-website}/public/ ${hugo-website-root}
        chown -R nginx:nginx ${hugo-website-root}
      '';
      unitConfig.Before = "nginx.service";
      wantedBy = ["multi-user.target"];
    };

    rebuild-about-website = {
      enable = true;
      description = "Rebuilds about website";
      script = ''
        if [ ! -d ${about-website-root} ]; then
          echo "Website directory doesn't exist, creating..."
          mkdir -p ${about-website-root}

          echo "Setting permissions on newly created directory..."
          chown nginx:nginx ${about-website-root}
        fi

        ${pkgs.rsync}/bin/rsync -avz --delete ${about-website}/public/ ${about-website-root}
        chown -R nginx:nginx ${about-website-root}
      '';
      unitConfig.Before = "nginx.service";
      wantedBy = ["multi-user.target"];
    };
  };
}
