let
  inherit (import ../pkgs.nix) nixpkgs shell;
  pkgs = import nixpkgs {};
in shell {
  terraform = pkgs.terraform_0_12.withPlugins (p: with p; [
    (pkgs.callPackage ./terraform-provider-vultr.nix {})
  ]);
  extraShellHook = ''
    echo '
    You need to set the Vultr API key:

    $ export VULTR_API_KEY=<your_vultr_api_key>
    '
  '';
}
