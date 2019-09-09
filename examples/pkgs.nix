rec {
  nixpkgs =
    fetchTarball {
      name = "nixos-unstable-24-07-19";
      url = "https://github.com/NixOS/nixpkgs-channels/archive/b5f5c97f7d67a99b67731a8cfd3926f163c11857.tar.gz";
      sha256 = "1m9xb3z3jxh0xirdnik11z4hw95bzdz7a4p3ab7y392345jk1wgm";
    };

  shell =
    { pkgs ? import nixpkgs {}
    , terranix ? import ./.. { inherit pkgs; }
    , terraform
    }: pkgs.mkShell rec {
      name = "terranix-shell";

      buildInputs = with pkgs; [ git-crypt terraform terranix ];

      SSH_KEY = toString ./ssh_key;
      NIX_PATH = "nixpkgs=${pkgs.path}";

      shellHook = ''
        addKey() {
          test -f "$SSH_KEY" \
            || ssh-keygen -f "$SSH_KEY" -q -N ""
          chmod 600 "$SSH_KEY"
          ssh-add "$SSH_KEY"
        }

        addKey
      '';
    };
}
