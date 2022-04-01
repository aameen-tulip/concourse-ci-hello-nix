{ pkgs             ? import <nixpkgs> {}
, mkShell          ? pkgs.mkShell
, fly              ? pkgs.fly
, docker           ? pkgs.docker
, docker-compose   ? pkgs.docker-compose
, concourse-docker ? pkgs.callPackage ./concourse-docker.nix {}
}:
mkShell {
  buildInputs = [
    fly
    docker
    docker-compose
    concourse-docker
  ];

  DOCKER_COMPOSE_YML = "${concourse-docker}/docker-compose.yml";

  shellHook = ''
    echo "The Concourse CI docker-compose.yml file is set as an env variable";
    echo "  DOCKER_COMPOSE_YML = $DOCKER_COMPOSE_YML";
    echo "";

    function concourse_docker() {
      ${docker-compose}/bin/docker-compose -f $DOCKER_COMPOSE_YML $@;
    }

    function concourse_up() {
      concourse_docker up -d;
    }
    function concourse_down() {
      concourse_docker down --remove-orphans;
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
