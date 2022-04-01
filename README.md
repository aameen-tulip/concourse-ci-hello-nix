# concourse-ci-hello-nix

```sh
nix --experimental-features 'nix-command flakes' develop;
concourse_up;
# ...
concourse_down;
exit;
```
