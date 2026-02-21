# NixOS flake

## hosts

### NixOS

```
nixos-rebuild switch --flake .#<hostname>
```

### home manager

```
home-manager switch --flake .#work
```

### virtual machines

```
nix build -L '.#nixosConfigurations.vm.config.system.build.vmWithDisko'
./result/bin/disko-vm
```

## deploy using colmena

```
colmena apply
```


## SD installer images

```
nix build .#images.sd-image-orange-pi-aarch64
nix build .#images.sd-image-raspberry-pi-aarch64
```
