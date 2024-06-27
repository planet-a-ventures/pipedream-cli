# Pipedream CLI

This is a Nix flake for the [Pipedream CLI](https://pipedream.com/docs/cli/install).

## Usage

### With flakes

```nix
inputs.pipedream-cli.url = "github:planet-a-ventures/pipedream-cli";
```

and then

```nix
buildInputs = [
    inputs.pipedream-cli.packages.${system}.default
];
```

> If anyone wanted to contribute a `flakeModule`
> via [flake-parts](https://flake.parts/) that would be highly appreciated.

## Development

### Update the hashes

1. Update the version in `config.nix`
1. Run:

```sh
nix-build generate-update-script.nix -o update-hashes && ./update-hashes/bin/update-hashes
```

### Direnv

This repo is [direnv](https://direnv.net/)-enabled. If you have Nix and direnv
on your system, you can ignore any `nix develop --command` prefixes and just
work in the folder as if you were inside the nix flake environment. This is the
recommended way, as it greatly simplifies the handling of dev tasks and
pre-commit checks.

### Pre commit hooks

Pre-commit hooks are managed by Nix. Once you run your commit, it will analyze
the changes and run required hooks.
