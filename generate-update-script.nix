{ pkgs ? import <nixpkgs> { } }:

let
  config = import ./config.nix;
  version = config.version;

  systems = config.supportedSystems;
  lib = pkgs.lib;
  getUrl = import ./url.nix { inherit lib; };

  urls = map
    (system:
      let
        url = getUrl {
          cpuOs = system;
          version = version;
        };
      in
      {
        system = system;
        url = url;
      })
    systems;

  fetchCommands = pkgs.lib.concatMapStringsSep "\n"
    (entry: ''
      echo "Prefetching ${entry.system}..."
      hash=$(nix-prefetch-url ${entry.url})
      echo "  \"${entry.system}\" = \"$hash\";" >> $HASHES_FILE
    '')
    urls;
in
pkgs.writeScriptBin "update-hashes" ''
  #!/usr/bin/env bash

  set -euo pipefail

  HASHES_FILE="hashes.nix"

  cat <<EOF > $HASHES_FILE
  {
  EOF

  ${fetchCommands}

  cat <<EOF >> $HASHES_FILE
  }
  EOF
''
