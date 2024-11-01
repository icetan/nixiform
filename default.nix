let
  mkBin = binName: {
    stdenv, makeWrapper, lib, shellcheck,
    glibcLocales, coreutils, gzip, gnused, gnugrep, gnutar, openssh, git, jq,
    nix, nix-diff
  }: stdenv.mkDerivation rec {
    name = "${binName}-${version}";
    version = lib.fileContents "${./lib}/${binName}-version";
    src = lib.sourceByRegex ./. [
      "bin" "bin/.*"
      "lib" "lib/.*"
    ];

    nativeBuildInputs = [ makeWrapper shellcheck ];
    buildPhase = "true";
    installPhase = let
      path = lib.makeBinPath [
        coreutils gzip gnused gnugrep gnutar openssh git jq
        nix nix-diff
      ];
      locales = lib.optionalString (glibcLocales != null)
        "--set LOCALE_ARCHIVE \"${glibcLocales}\"/lib/locale/locale-archive";
    in ''
      mkdir -p $out/{bin,lib}
      cp ./bin/${binName} $out/bin
      cp -r -t $out/lib ./lib/*
      wrapProgram "$out/bin/${binName}" --argv0 ${binName} --prefix PATH : "${path}" ${locales}
    '';

    doCheck = true;
    checkPhase = ''
      shellcheck -x bin/* lib/{infect,configurators/*}
    '';

    meta = with lib; {
      description = "Nixiform deploy NixOS configurations";
      homepage = https://github.com/icetan/nixiform;
      license = licenses.gpl3;
      inherit version;
    };
  };
in
{ system ? builtins.currentSystem
, pkgs ? import (import ./shim.nix).inputs.nixpkgs { inherit system; }
}: {
  nixiform = pkgs.callPackage (mkBin "nixiform") {};
  terraflake = pkgs.callPackage (mkBin "terraflake") {};
  tonix = pkgs.callPackage (mkBin "tonix") {};
}
