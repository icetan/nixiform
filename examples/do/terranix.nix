let
  httpServer = content: { pkgs, ... }: {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.nginx = {
      enable = true;
      virtualHosts.localhost = {
        locations."/" = {
          root = pkgs.runCommand "hej" {} ''
            mkdir -p $out
            printf %s '${content}' > $out/index.html
          '';
        };
      };
    };
  };
in {
  "do-1" = { config, ... }: {
    require = [
      (httpServer ''
        hej hej Im nixos-1 : ${config.terranix.do-1.ip}
      '')
    ];
  };
}
