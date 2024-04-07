let
  common = import ../common.nix;
in input: {
  "server" = { config, input, ... }: {
    imports = [ (common.http-server ''
      Hi I'm a lonely Hetzner instance
      ${common.info input.nodes}
    '') ];
  };
}
