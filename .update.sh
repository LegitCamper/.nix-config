#!/usr/bin/bash
# updates nixos systems

cd ~/projects/.nix-config

git pull

# decrypt nix.conf github token
ansible-vault decrypt ~/.config/nix/nix.conf

cachix use nix-community
cachix use helix

nix flake check --all-systems

nix flake update --accept-flake-config

sudo nixos-rebuild switch --upgrade-all --flake .# #--install-bootloader --use-remote-sudo --impure --use-substitutes

nix-env --delete-generations 14d

# nix-store --gc

cd -
