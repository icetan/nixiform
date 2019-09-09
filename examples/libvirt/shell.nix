let
  inherit (import ../pkgs.nix) nixpkgs shell;
  pkgs = import nixpkgs {};
in shell {
  terraform = pkgs.terraform_0_12.withPlugins (p: with p; [
    template
    (pkgs.callPackage ./terraform-provider-libvirt.nix {})
  ]);
  extraShellHook = ''
    echo '
    Install and start `libvirt` then make sure to create and start the default
    `pool` and `net`:

    $ virsh --connect "qemu:///system" pool-define-as default dir - - - - /var/lib/libvirt/images
    $ virsh --connect "qemu:///system" pool-start default
    $ virsh --connect "qemu:///system" net-start default
    '
  '';
}
