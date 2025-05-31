{ pkgs }: let

website-root = "/var/www/megacorp.industries";

hugo-website = pkgs.stdenv.mkDerivation {
  name = "hugo-website";

  src = pkgs.fetchFromGitHub {
    owner = "rapture-mc";
    repo = "hugo-website";
    rev = "a012c0e14b21621100093deaeceb030e53db9f6d";
    hash = "sha256-tgNiwmupVlI61Hly1h1pTbhmN3QJenlPflqux6k9hL8=";
  };

  installPhase = ''
    mkdir $out

    ${pkgs.hugo}/bin/hugo

    cp -rv $src/public $out
  '';
};
in {
  services.nginx.virtualHosts = {
    "megacorp.industries" = {
      forceSSL = true;
      enableACME = true;
      # locations."/".proxyPass = "http://${vars.networking.hostsAddr.MGC-DRW-HVS02.eth.ipv4}:80";
      root = website-root;
    };
  };

  systemd.services.rebuild-website = {
    enable = true;
    description = "Rebuilds hugo website";
    script = ''
      if [ -d ${website-root} ]; then
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
