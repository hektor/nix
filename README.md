# nixos

## Set up virtual machine ([`disko`](https://github.com/nix-community/disko/blob/master/docs/interactive-vm.md))

1. Build the virtual machine

```
nix run -L '.#nixosConfigurations.vm.config.system.build.vmWithDisko'
```

2. Run the virtual machine

```
QEMU_KERNEL_PARAMS=console=ttyS0 ./result/bin/run-nixos-vm -nographic; reset
```
