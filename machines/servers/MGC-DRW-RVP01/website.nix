{pkgs}: let
  hugo-website-root = "/var/www/megacorp.industries";

  about-website-root = "/var/www/cloak.megacorp.industries";

  hugo-website = pkgs.stdenv.mkDerivation {
    name = "hugo-website";

    src = pkgs.fetchFromGitHub {
      owner = "rapture-mc";
      repo = "hugo-website";
      rev = "60edb6a7cc732c96068b392e37572a3897f6d635";
      hash = "sha256-u9Umpzn+x+fdEOnCXIIGiDQfkGY85Agh0dkm1BOxUPM=";
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
      repo = "hugo-cv";
      rev = "52d944ecbdcbd4d5c4e73b21f57890761f914bb6";
      hash = "sha256-xa9d+97/bIz93HH4LMtbs0otV5RnXK5CzDuVqoGesIM=";
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

    "cloak.megacorp.industries" = {
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
