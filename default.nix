let
  terranix = {
    stdenv, makeWrapper, lib, shellcheck,
    glibcLocales, coreutils, gzip, gnused, gnutar, jq, openssh, nix, git
  }: stdenv.mkDerivation rec {
    name = "terranix-${version}";
    version = "0.0.0";
    src = lib.sourceByRegex ./. [
      ".*bin.*"
      ".*lib.*"
    ];

    nativeBuildInputs = [ makeWrapper shellcheck ];
    buildPhase = "true";
    installPhase = let
      path = lib.makeBinPath [
        coreutils gzip gnused gnutar jq openssh nix git
      ];
      locales = lib.optionalString (glibcLocales != null)
        "--set LOCALE_ARCHIVE \"${glibcLocales}\"/lib/locale/locale-archive";
    in ''
      mkdir -p $out/{bin,lib}
      cp -r -t $out/bin ./bin/*
      cp -r -t $out/lib ./lib/*
      wrapProgram "$out/bin/terranix" --set PATH "${path}" ${locales}
    '';

    doCheck = true;
    checkPhase = ''
      shellcheck -x bin/* lib/{infect,configurators/*}
    '';

    meta = with lib; {
      description = "TerraNix deploy NixOS configurations";
      homepage = https://github.com/icetan/terranix;
      license = licenses.gpl3;
      inherit version;
    };
  };
in { pkgs ? import <nixpkgs> {} }: pkgs.callPackage terranix {}
