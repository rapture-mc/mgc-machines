{ pkgs }: let

website-root = "/var/www/megacorp.industries";

hugo-website = pkgs.stdenv.mkDeriviation {
  name = "hugo-website";

  src = pkgs.fetchFromGitHub {
    owner = "rapture-mc";
    repo = "hugo-website";
    rev = "a012c0e14b21621100093deaeceb030e53db9f6d";
    hash = "sha256-tgNiwmupVlI62Hly1h1pTbhmN3QJenlPflqux6k9hL8=";
  };

  installPhase = ''
    mkdir $out

    ${pkgs.rsync}/bin/rsync -avz --delete public/ ${website-root}
    chown -R nginx:nginx ${website-root}
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

      cd ${hugo-website}
      ${pkgs.hugo}/bin/hugo 
      ${pkgs.rsync}/bin/rsync -avz --delete public/ ${website-root}
      chown -R nginx:nginx ${website-root}
    '';
    unitConfig.Before = "nginx.service";
    wantedBy = ["multi-user.target"];
  };
}
