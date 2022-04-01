{ stdenv
, fly
}:
stdenv.mkDerivation {
  pname   = "concourse-hello";
  version = "0.0.0";
  buildInputs = [
    fly
  ];
  src = ./.;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share
    touch $out/share/f
  '';
  dontFixup = true;
}
