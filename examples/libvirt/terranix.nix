let
  # libvirt specific configuration
  virtlib = ./libvirt_nixos/conf.nix;

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
  "nixos-1" = { config, ... }: { require = [ virtlib (httpServer ''
    hej hej Im nixos-1 : ${config.terranix.nixos-1.ip}
  '') ]; };
  "nixos-2" = { config, ... }: { require = [ virtlib (httpServer ''
    hello my name is nixos-2 and my IP is ${config.terranix.nixos-2.ip}
  '') ]; };
}
