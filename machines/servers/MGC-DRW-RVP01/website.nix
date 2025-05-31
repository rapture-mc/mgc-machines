{ pkgs }: let
hugo-website = pkgs.fetchFromGitHub {
  owner = "rapture-mc";
  repo = "hugo-website";
  hash = "";
};

website-root = "/var/www/megacorp.industries";

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
