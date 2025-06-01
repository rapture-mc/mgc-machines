{ pkgs }: let

website-root = "/var/www/megacorp.industries";

hugo-website = pkgs.stdenv.mkDerivation {
  name = "hugo-website";

  src = pkgs.fetchFromGitHub {
    owner = "rapture-mc";
    repo = "hugo-website";
    rev = "c85a24315191a2dcc6eee7a94d95bcee06e5df20";
    hash = "sha256-8WgPCfyauzxy5IkCAZ1AWSXWeouz+o3fn9kLrkiddCY=";
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
