{ lib }:

let getGoArch = import ./cpuOsToGoArch.nix { inherit lib; };
in { cpuOs, version }:
let
  arch = getGoArch { cpuOs = cpuOs; };
  # See: https://cli.pipedream.com/install
  url = "https://cli.pipedream.com/${arch}/${version}/pd.zip";
in
url
