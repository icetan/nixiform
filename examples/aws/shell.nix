let
  inherit (import ../pkgs.nix) nixpkgs shell;
  pkgs = import nixpkgs {};
in shell {
  terraform = pkgs.terraform_0_12.withPlugins (p: with p; [
    aws
  ]);
  extraShellHook = ''
    echo '
    You need to set the AWS API key:

    $ export AWS_ACCESS_KEY_ID=<your_aws_access_key_id>
    $ export AWS_SECRET_ACCESS_KEY=<your_aws_secret_access_key>
    '
  '';
}
