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

## docs

* [deploy using colmena](./deploy/README.md)
* [SD installer images](./images/README.md)
