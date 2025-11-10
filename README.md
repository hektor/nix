# NixOS flake

## Set up virtual machine ([`disko`](https://github.com/nix-community/disko/blob/master/docs/interactive-vm.md))

1. Build the virtual machine

```
nix build -L '.#nixosConfigurations.vm.config.system.build.vmWithDisko'
```

2. Run the virtual machine

```
./result/bin/disko-vm
```
