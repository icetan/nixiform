{ buildGoPackage, fetchFromGitHub }:

let
  toDrv = data:
    buildGoPackage rec {
      inherit (data) owner repo version sha256;
      name = "${repo}-${version}";
      goPackagePath = "github.com/${owner}/${repo}";
      subPackages = [ "." ];
      src = fetchFromGitHub {
        inherit owner repo sha256;
        rev = "v${version}";
      };


      # Terraform allow checking the provider versions, but this breaks
      # if the versions are not provided via file paths.
      postBuild = "mv go/bin/${repo}{,_v${version}}";
    };
in toDrv {
  owner = "vultr";
  repo = "terraform-provider-vultr";
  version = "1.0.4";
  sha256 = "04qh092i6ahiqffxbqc1hh4yqw2xw4fvywi39vbgaagkvrc3hfp9";
}
