{ nixpkgs, pkgs, ... }: let

version = "2.10.4";

godap = pkgs.buildGoModule {
  pname = "godap";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "Macmod";
    repo = "godap";
    rev = "v${version}";
    hash = "sha256-mvzVOuFZABGE7DH3AkhOXvsvSZzgpW0aJUdXW6N6hf0=";
  };

  vendorHash = "sha256-NiNhKbf5bU1SQXFTZCp8/yNPc89ss8go6M2867ziqq4=";

  meta = with nixpkgs.lib; {
    homepage = "https://github.com/Macmod/godap";
    description = "TUI for LDAP";
    license = licenses.mit;
  };
};
in {
  environment.systemPackages = [ godap ];

  networking.firewall.allowedTCPPorts = [
    389
    # 636
  ];

  services.openldap = {
    enable = true;

    /* enable plain connections only */
    urlList = [
      "ldap:///"
      # "ldaps:///"
    ];

    settings = {
      attrs = {
        olcLogLevel = "conns config";

        /* settings for acme ssl */
        # olcTLSCACertificateFile = "/var/lib/acme/MGC-DRW-HVS01/full.pem";
        # olcTLSCertificateFile = "/var/lib/acme/MGC-DRW-HVS01/cert.pem";
        # olcTLSCertificateKeyFile = "/var/lib/acme/MGC-DRW-HVS01/key.pem";
        # olcTLSCipherSuite = "HIGH:MEDIUM:+3DES:+RC4:+aNULL";
        # olcTLSCRLCheck = "none";
        # olcTLSVerifyClient = "never";
        # olcTLSProtocolMin = "3.1";
      };

      children = {
        "cn=schema".includes = [
          "${pkgs.openldap}/etc/schema/core.ldif"
          "${pkgs.openldap}/etc/schema/cosine.ldif"
          "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
          "${pkgs.openldap}/etc/schema/nis.ldif"
        ];

        "olcDatabase={1}mdb".attrs = {
          objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];

          olcDatabase = "{1}mdb";
          olcDbDirectory = "/var/lib/openldap/data";

          olcSuffix = "dc=megacorp,dc=industries";

          olcRootDN = "cn=admin,dc=megacorp,dc=industries";
          olcRootPW.path = "/run/secrets/olcRootPW";

          olcAccess = [
            /* custom access rules for userPassword attributes */
            ''{0}to attrs=userPassword
                by self write
                by anonymous auth
                by * none''

            /* allow read on anything else */
            ''{1}to *
                by * read''
          ];
        };
      };
    };

    declarativeContents = {
      "dc=megacorp,dc=industries" = 
        import ./ou-structure.nix +
        import ./users.nix;
    };
  };

  /* ensure openldap is launched after certificates are created */
  # systemd.services.openldap = {
  #   wants = [ "acme-MGC-DRW-HVS01.service" ];
  #   after = [ "acme-MGC-DRW-HVS01.service" ];
  # };
  #
  # security.acme.acceptTerms = true;
  # security.acme.defaults.email = "someone@somedomain.com";
  #
  # /* make acme certificates accessible by openldap */
  # security.acme.defaults.group = "certs";
  # users.groups.certs.members = [ "openldap" ];
  #
  # /* trigger the actual certificate generation for your hostname */
  # security.acme.certs."MGC-DRW-HVS01" = {
  #   extraDomainNames = [];
  # };
}
