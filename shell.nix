{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [ pkgs.pd ];

  shellHook = ''
    echo "To install the binary, run: nix build
  '';
}
