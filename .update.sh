#!/usr/bin/bash
# updates nixos systems and tools

cd ~/projects/.nix-config

git pull

# decrypt nix.conf github token
if [[ $(head -n 1 ~/.config/nix/nix.conf) == *ANSIBLE_VAULT* ]]; then
  ansible-vault decrypt ~/.config/nix/nix.conf
else
  echo "Vault already decrypted"
fi

if [ $1 == system ]; then
  cachix use nix-community
  cachix use helix

  nix flake update --accept-flake-config
  sudo nixos-rebuild switch --upgrade-all --flake .# #--install-bootloader --use-remote-sudo --impure --use-substitutes
  nix-env --delete-generations 14d
  # nix-store --gc
elif [ $1 == home ]; then 
  home-manager switch

elif [ $1 == check ]; then
  nix flake check --all-systems --no-build

else
  echo "Arg must be one of the following: 'system' for system upgrades or 'home' for home upgrades"

fi

# update other tools
nix-shell -p clang --run "hx --grammar fetch && hx --grammar build"

cd -
