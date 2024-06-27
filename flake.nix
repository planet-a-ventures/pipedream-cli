{
  description = "Pipedream CLI utility";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hashes = {
      url = "path:./hashes.nix";
      flake = false;
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = inputs@{ flake-parts, nixpkgs, hashes, ... }:
    let
      version = "0.3.3";
      systems = builtins.attrNames hashes;
      lib = inputs.nixpkgs.lib;
      getUrl = import ./url.nix { inherit lib; };
      hashes = import inputs.hashes;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [ ];

      systems = systems;

      perSystem = { config, self', inputs', pkgs, system, ... }: rec {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "pd";
          version = version;
          # Not using fetchzip due to https://github.com/NixOS/nixpkgs/issues/111508
          src = pkgs.fetchurl {

            url = getUrl {
              cpuOs = system;
              version = version;
            };
            sha256 = lib.getAttrFromPath [ system ] hashes;
          };
          nativeBuildInputs = with pkgs; [ unzip ];

          # Work around the "unpacker appears to have produced no directories"
          # case that happens when the archive doesn't have a subdirectory.
          sourceRoot = ".";

          installPhase = ''
            mkdir -p $out/bin
            cp -r * $out/bin
          '';
        };

        checks = {
          pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              markdownlint.enable = true;
            };
          };
        };
        devShells.default = pkgs.mkShell {
          inherit (checks.pre-commit-check) shellHook;
          buildInputs = [ packages.default ] ++ checks.pre-commit-check.enabledPackages;
        };
      };

      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
      };
    };
}
