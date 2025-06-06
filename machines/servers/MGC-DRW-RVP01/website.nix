{pkgs}: let
  hugo-website-root = "/var/www/megacorp.industries";

  about-website-root = "/var/www/cloak.megacorp.industries";

  hugo-website = pkgs.stdenv.mkDerivation {
    name = "hugo-website";

    src = pkgs.fetchFromGitHub {
      owner = "rapture-mc";
      repo = "hugo-website";
      rev = "29d1e61967c13dc6284e755ba3864d98d0ed0044";
      hash = "sha256-MhYMB0oAo4IGIcyBHBNgKXvIZqN9u15LvqIs/pge1cg=";
    };

    installPhase = ''
      mkdir $out

      ${pkgs.hugo}/bin/hugo

      cp -rv public $out
    '';
  };

  about-website = pkgs.stdenv.mkDerivation {
    name = "hugo-website";

    src = pkgs.fetchFromGitHub {
      owner = "rapture-mc";
      repo = "about-website";
      rev = "0c3da0ce20dd626077648edf710ac2f0ca369170";
      hash = "";
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
