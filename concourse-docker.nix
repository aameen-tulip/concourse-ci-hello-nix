{ stdenv }:
stdenv.mkDerivation {
  pname = "concourse-docker";
  version = "0.0.0";
  src = builtins.fetchurl {
    url = "https://concourse-ci.org/docker-compose.yml";
    sha256 = "1wwdlg0d4i84ivr1w01v5gabiwpy0rw5zxinc0apc9vsvx7li1fb";
  };
  dontUnpack    = true;
  dontPatch     = true;
  dontConfigure = true;
  installPhase = ''
    mkdir -p $out
    cp -p --reflink=auto -- $src $out/docker-compose.yml
  '';
  dontFixup     = true;
}
