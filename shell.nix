let
  sources = import ./lon/lon.nix;
  pkgs = import sources.nixpkgs { };
  default = import ./default.nix { };
in
pkgs.mkShell {
  packages =
    with pkgs;
    [
      (pkgs.callPackage "${sources.lon}/nix/packages/lon.nix" { })
    ]
  ;

  LON_DIRECTORY = "lon";
}
