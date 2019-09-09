let
	inherit (import ../pkgs.nix) nixpkgs shell;
  pkgs = import nixpkgs {};
in shell {
  terraform = pkgs.terraform_0_11.withPlugins (p: with p; [ aws ]);
}
