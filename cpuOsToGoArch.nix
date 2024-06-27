{ lib }:

let
  cpuOsToGoArch = {
    "x86_64-linux" = "linux/amd64";
    "i686-linux" = "linux/386";
    "aarch64-linux" = "linux/amd64";
    "armv7l-linux" = "linux/arm";
    "x86_64-darwin" = "darwin/amd64";
    "aarch64-darwin" = "darwin/amd64";
    "x86_64-windows" = "windows/amd64";
    "i686-windows" = "windows/386";
    "x86_64-freebsd" = "freebsd/amd64";
    "aarch64-freebsd" = "freebsd/amd64";
    "x86_64-openbsd" = "openbsd/amd64";
    "aarch64-openbsd" = "openbsd/amd64";
  };
in
{ cpuOs }:
let goArch = lib.getAttrFromPath [ cpuOs ] cpuOsToGoArch;
in if goArch == null then
  throw "Unsupported CPU-OS string: ${cpuOs}"
else
  goArch
