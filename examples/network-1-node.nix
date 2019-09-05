let
  common = import ./common.nix;
in {
  "node-1" = { config, ... }: {
    require = [ (common.http-server ''
      hej hej I'm node-1
      ${common.info config.terranix}
    '') ];
  };
}
