let
  inherit (import ../pkgs.nix) nixpkgs shell;
  pkgs = import nixpkgs {};
in shell {
  terraform = pkgs.terraform_0_12.withPlugins (p: with p; [
    hcloud
  ]);
  extraShellHook = ''
    echo '
    You need to set the Hetzner API token:

    $ export HCLOUD_TOKEN=<your_hcloud_api_token>
    '
  '';
}
