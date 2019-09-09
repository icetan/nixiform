{ nixpkgs ? fetchTarball {
    name = "nixos-unstable-24-07-19";
    url = "https://github.com/NixOS/nixpkgs-channels/archive/b5f5c97f7d67a99b67731a8cfd3926f163c11857.tar.gz";
    sha256 = "1m9xb3z3jxh0xirdnik11z4hw95bzdz7a4p3ab7y392345jk1wgm";
  }
}:

let
  pkgs = (import nixpkgs {});

  terranix = import ./.. { inherit pkgs; };
  terraform = pkgs.terraform_0_11.withPlugins (p: with p; [
    libvirt template digitalocean aws hcloud
    (pkgs.callPackage ./vultr/terraform-provider-vultr.nix {})
  ]);
in
  pkgs.mkShell rec {
    name = "terranix-shell";

    buildInputs = with pkgs; [ git-crypt terraform terranix ];

    ROOT_DIR = toString ./.;
    NIX_PATH = "nixpkgs=${pkgs.path}";

    shellHook = ''
      addKey() {
        test -f "$ROOT_DIR"/ssh_key \
          || ssh-keygen -f "$ROOT_DIR"/ssh_key -q -N ""
        chmod 600 "$ROOT_DIR"/ssh_key
        ssh-add "$ROOT_DIR"/ssh_key
      }

      addKey
    '';
  }
