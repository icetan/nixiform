{
  http-server = content: { pkgs, ... }: {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.nginx = {
      enable = true;
      virtualHosts.localhost = {
        locations."/" = {
          root = pkgs.runCommand "http-server-content" {} ''
            mkdir -p $out
            cat > $out/index.html <<EOF
            <pre>
            ${content}
            </pre>
            EOF
            '';
        };
      };
    };
  };

  info = with builtins; cfg:
    concatStringsSep "" (map (x: ''

      ${x.name}
      ==============
      provider: ${x.provider}
      ip: ${x.ip}
      '') (attrValues cfg)
    );
}
