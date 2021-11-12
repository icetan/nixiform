{
  description = "Nixiform = Nix + Terraform";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          nixiform = import ./. { inherit pkgs; };
        in {
          devShell = nixiform;
          defaultPackage = nixiform;
          packages.nixiform = nixiform;
          defaultApp = {
            type = "app";
            program = "nixiform";
          };
        }
      );
}
