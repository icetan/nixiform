# DO NOT EDIT generated by terraflake

{ pkgs, ... }: let
  inherit (pkgs) writeText;
  tf = import ../terraflake.nix;
  input = tf.input or { nodes = { }; meta = { }; };
in
{
  terraflake.input = input;
}
