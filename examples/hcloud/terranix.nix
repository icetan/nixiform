let
  common = import ../common.nix;
in input: {
  "server" = { config, input, ... }: {
    require = [ (common.http-server ''
      Hi I'm a lonely Hetzner instance
      ${common.info input.nodes}
    '') ];
  };
}
