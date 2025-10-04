# nixos

My NixOS config

```
git clone https://git.hektormisplon.xyz/hektor/nix.git
cd nix
sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko/latest#disko-install' -- --flake .#vm --disk root /dev/vda
```
