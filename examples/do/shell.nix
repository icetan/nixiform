let
  inherit (import ../pkgs.nix) nixpkgs shell;
  pkgs = import nixpkgs {};
in shell {
  terraform = pkgs.terraform_0_12.withPlugins (p: with p; [
    digitalocean
  ]);
  extraShellHook = ''
    echo '
    You need to set the DigitalOcean API token:

    $ export DIGITALOCEAN_TOKEN=<your_do_api_token>
    '
  '';
}
