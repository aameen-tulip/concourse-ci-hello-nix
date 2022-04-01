{ pkgs             ? import <nixpkgs> {}
, mkShell          ? pkgs.mkShell
, fly              ? pkgs.fly
, docker           ? pkgs.docker
, concourse-docker ? pkgs.callPackage ./concourse-docker.nix {}
}:
mkShell {
  buildInputs = [
    fly
    docker
    concourse-docker
  ];

  CONCOURSE_DOCKER_COMPOSE_YML = "${concourse-docker}/docker-compose.yml";

  shellHook = ''
    echo "The Concourse CI docker-compose.yml file is set as an env variable";
    echo "  CONCOURSE_DOCKER_COMPOSE_YML = $CONCOURSE_DOCKER_COMPOSE_YML";
    echo "";

    function concourse_up() {
      ${docker}/bin/docker-compose up -d -f $CONCOURSE_DOCKER_COMPOSE_YML;
    }
    function concourse_down() {
      ${docker}/bin/docker-compose down -d -f $CONCOURSE_DOCKER_COMPOSE_YML;
    }
    echo "The shell function concourse_up and concourse_down start/kill";
    echo "docker-compose running the Concourse CI image.";
    echo "The Councourse CI image serves to 'http://localhost:8080'.";
    echo "";

    function shell_exit_hook() {
      concourse_down;
      exit;
    }
    trap shell_exit_hook HUP INT QUIT ABRT;
    echo "concourse_down will be called automatically when this shell exits.";
    echo "";
  '';
}
