let
  common = import ./common.nix;
in builtins.mapAttrs (name: node:
  { config, input, ... }: {
    require = [ (common.http-server ''
      hej hej I'm ${name} (hej = ${node.ip})
      ${common.info input}
    '') ];
  })
