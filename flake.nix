{
  description = "A Concourse CI pipeline for a trivial hello-world program";

  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem ( system:
      let
        pkgsFor = nixpkgs.legacyPackages.${system};
      in rec {
        packages = flake-utils.lib.flattenTree ( rec {
          concourse-docker = pkgsFor.callPackage ./concourse-docker.nix {};
          concourse-hello = pkgsFor.callPackage ./default.nix {};
        } );
        defaultPackage = packages.concourse-hello;

        devShells = flake-utils.lib.flattenTree {
          concourse-hello = pkgsFor.callPackage ./shell.nix {
            inherit (packages) concourse-docker;
          };
        };
        devShell = devShells.concourse-hello;
      }
    );
}
