let
  nixiform = {
    stdenv, makeWrapper, lib, shellcheck,
    glibcLocales, coreutils, gzip, gnused, gnugrep, gnutar, jq, openssh, nix, git
  }: stdenv.mkDerivation rec {
    name = "nixiform-${version}";
    version = lib.fileContents ./lib/version;
    src = lib.sourceByRegex ./. [
      "bin" "bin/.*"
      "lib" "lib/.*"
    ];

    nativeBuildInputs = [ makeWrapper shellcheck ];
    buildPhase = "true";
    installPhase = let
      path = lib.makeBinPath [
        coreutils gzip gnused gnugrep gnutar jq openssh nix git
      ];
      locales = lib.optionalString (glibcLocales != null)
        "--set LOCALE_ARCHIVE \"${glibcLocales}\"/lib/locale/locale-archive";
    in ''
      mkdir -p $out/{bin,lib}
      cp -r -t $out/bin ./bin/*
      cp -r -t $out/lib ./lib/*
      wrapProgram "$out/bin/nixiform" --argv0 nixiform --prefix PATH : "${path}" ${locales}
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
in { pkgs ? import <nixpkgs> {} }: pkgs.callPackage nixiform {}
