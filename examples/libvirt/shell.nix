let
	inherit (import ../pkgs.nix) nixpkgs shell;
  pkgs = import nixpkgs {};
in shell {
  terraform = pkgs.terraform_0_12.withPlugins (p: with p; [
    template
    (pkgs.callPackage ./terraform-provider-libvirt.nix {})
  ]);
}
