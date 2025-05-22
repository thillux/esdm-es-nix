let
  sources = import ./lon/lon.nix;

  pkgs = import sources.nixpkgs { };

  inherit (pkgs) lib;

in

{
  esdm_es = pkgs.callPackage ./nix/esdm_es.nix { kernel = pkgs.linux_latest; };
}