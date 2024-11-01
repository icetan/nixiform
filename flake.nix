{
  description = "Nixiform = Nix + Terraform";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          packages = import ./. { inherit pkgs; };
        in
        {
          packages = packages // {
            default = self.outputs.packages.${system}.nixiform;
          };
          devShells.default = self.outputs.packages.${system}.nixiform;
          apps.nixiform = { type = "app"; program = "nixiform"; };
          apps.default = self.outputs.apps.${system}.nixiform;
          apps.terraflake = { type = "app"; program = "terraflake"; };
          apps.tonix = { type = "app"; program = "tonix"; };
        }
      );
}
