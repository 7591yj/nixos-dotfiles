{ pkgs ? import <nixpkgs> {} }:
{
  nvf = pkgs.callPackage ./nvf {};
}
