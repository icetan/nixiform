let
  common = import ./common.nix;
in input: builtins.mapAttrs (name: node:
  { config, input, ... }: {
    imports = [ (common.http-server ''
      Nej nej 6: hej I'm ${name} (ip = ${node.ip})
      ${common.info input.nodes}
    '') ];
  }) input.nodes
