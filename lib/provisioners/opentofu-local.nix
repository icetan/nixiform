# DO NOT EDIT generated by terraflake

{ pkgs, ... }:
let
  pkgs' = import pkgs.path { system = builtins.currentSystem; };
  inherit (pkgs') opentofu jq runCommand;
  drv = runCommand "terraflake-opentofu-local-output"
    {
      buildInputs = [ opentofu jq ];
    }
    ''
      tofu output -json -state="${../terraform.tfstate}" \
      | jq > $out -rM '
      {
        meta: (to_entries
          | map(select(.key | test("^terraflake$") | not))
          | map({ (.key): .value.value })
          | add // {}),
        nodes: ([.terraflake.value]
          | flatten
          | map(select(.name!=null and .ip!=null and .ssh_key!=null))
          | map({ (.name): . })
          | add // {})
      }
      '
    '';
  input = pkgs'.lib.importJSON drv;
in
{
  nixiform.input = input;
  terraflake.input = input;
  tonix.input = input;
}
