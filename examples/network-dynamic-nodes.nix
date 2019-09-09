let
  common = import ./common.nix;
in input: builtins.mapAttrs (name: node:
  { config, input, ... }: {
    require = [ (common.http-server ''
      hej hej I'm ${name} (ip = ${node.ip})
      ${common.info input.nodes}
    '') ];
  }) input.nodes
