# building SD Images

## Raspberry Pi 3B+

```bash
nix build .#images.sd-image-raspberry-pi-aarch64
nix-shell -p zstd --run "zstdcat result/sd-image/*.img.zst | sudo dd of=/dev/sdX bs=4M status=progress conv=fsync"
```

## Orange Pi Zero2 H616
```bash
nix build .#images.sd-image-orange-pi-aarch64
nix-shell -p zstd --run "zstdcat result/sd-image/*.img.zst | sudo dd of=/dev/sdX bs=4M status=progress conv=fsync"
sudo dd if=~/dl/u-boot-sunxi-with-spl.bin of=/dev/sdX bs=1024 seek=8
```
