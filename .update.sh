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
  export NIXPKGS_ALLOW_UNFREE=1
  cachix use nix-community
  cachix use helix

  nix flake update --accept-flake-config
  sudo nixos-rebuild switch --upgrade-all --impure --flake .# #--install-bootloader --use-remote-sudo --impure --use-substitutes
  nix-env --delete-generations 14d
  # nix-store --gc
elif [ $1 == home ]; then 
  nix run home-manager/release-23.05 -- init --switch
  #nix run home-manager/master -- init --switch
  home-manager switch

elif [ $1 == check ]; then
  nix flake check --all-systems --no-build

else
  echo "Arg must be one of the following: 'system' for system upgrades or 'home' for home upgrades"

fi

# update other tools
nix-shell -p clang --run "hx --grammar fetch && hx --grammar build"
bash ~/projects/.dotfiles/.stow.sh

cd -
