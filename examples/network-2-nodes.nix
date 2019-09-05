let
  common = import ./common.nix;
in {
  "node-1" = { config, ... }: {
    require = [ (common.http-server ''
      hej hej I'm node-1
      ${common.info config.terranix}
    '') ];
  };
  "node-2" = { config, ... }: {
    require = [ (common.http-server ''
      hello my name is node-2
      ${common.info config.terranix}
    '') ];
  };
}
