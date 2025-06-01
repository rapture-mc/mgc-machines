{ pkgs }: let

website-root = "/var/www/megacorp.industries";

hugo-website = pkgs.stdenv.mkDerivation {
  name = "hugo-website";

  src = pkgs.fetchFromGitHub {
    owner = "rapture-mc";
    repo = "hugo-website";
    rev = "4e4ebc646d1686b56abfa702073278ed23199411";
    hash = "sha256-EEnbyO3hBjJcWBU0G+Q0woYrIvjz2i+Z7X+i/fjt8+I=";
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
