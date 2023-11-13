{ pkgs, inputs, ... }:
# pkgs is unstable
let stable = import inputs.nixpkgs-stable { config = { allowUnfree = true; }; };
in {
  home.username = "sawyer";
  home.homeDirectory = "/home/sawyer";

  home.packages = with pkgs; [
    #-- customize flake packages here
    inputs.nix-gaming.packages.${pkgs.system}.proton-ge
    inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    inputs.helix.packages.${stable.system}.default

    # overlay installation here 

    # Networking tools
    stable.inetutils # hostname ping ifconfig...
    stable.dnsutils # dig nslookup...
    stable.bridge-utils # brctl
    stable.iw
    stable.wirelesstools # iwconfig

    # nix
    stable.nixfmt # nix formatter
    stable.nil # nix lsp
    home-manager
    stable.nixpkgs-review
    stable.cachix

    # window manager
    pulseaudio
    stable.libsForQt5.qtstyleplugin-kvantum
    stable.lxqt.lxqt-qtplugin
    stable.papirus-icon-theme
    stable.networkmanagerapplet
    stable.lxappearance
    stable.dolphin
    stable.pavucontrol
    stable.blueman
    stable.xboxdrv
    stable.swayidle
    stable.swaybg
    stable.wofi
    stable.dunst
    stable.playerctl
    stable.waybar
    stable.grim
    stable.slurp
    stable.wl-clipboard
    stable.socat
    stable.brightnessctl
    stable.bash
    stable.fish
    stable.moreutils # sponge...
    stable.unzip
    stable.git
    stable.wget
    stable.htop
    stable.efibootmgr
    stable.ansible
    stable.usbutils # lsusb

    # apps
    stable.bitwarden
    stable.libsForQt5.dolphin
    stable.libsForQt5.ark
    stable.libsForQt5.kate
    stable.libsForQt5.gwenview
    stable.libsForQt5.kcalc
    stable.libsForQt5.elisa
    stable.emote
    stable.socat
    stable.qemu
    stable.libreoffice
    stable.vlc
    stable.gnome.pomodoro
    stable.ffmpeg-full
    stable.procs
    stable.solaar
    discord
    vivaldi
    vivaldi-ffmpeg-codecs
    stable.nuclear
    stable.obsidian

    # gaming
    stable.lutris
    stable.heroic
    stable.gamescope
    steamtinkerlaunch
    stable.minecraft
    stable.jre8 # for minecrfaft

    # cli
    stable.nmap
    stable.fd
    stable.bitwarden-cli
    stable.stow
    stable.alacritty
    stable.fd
    stable.fish
    stable.upower
    stable.htop
    stable.tldr
    stable.yt-dlp

    # dev
    stable.ansible-language-server
    stable.git
    stable.neovim
    stable.lazygit
    stable.gitui
    stable.lua-language-server
    stable.luaformatter # lua formatter
    stable.taplo # toml lsp
    stable.jq
    stable.fzf
    stable.docker
    stable.docker-ls
    stable.docker-compose
    stable.lazydocker
    stable.wireshark-qt
    stable.docker
    stable.docker-compose

    # rust tools
    eza # use from unstable
    stable.ripgrep
    stable.zellij
    stable.macchina
    stable.starship
    stable.zoxide
    # helix # replaced by flake
  ];

  # theme configuration
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Compact-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "compact";
        tweaks = [ "rimless" ]; # "black"
        variant = "macchiato";
      };
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.macchiatoMauve;
      name = "Catppuccin-Macchiato-Mauve-Cursors";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Catppuccin-Macchiato-Mauve-Icons";
    };
  };
  qt = {
    enable = true;
    style.package = pkgs.catppuccin-kvantum;
    style.name = "Catpuccin-Macchiato-Compact-Mauve-Dark";
    platformTheme = "gtk";
  };

  # home-manager program configs
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      full = false;
      no_display = true;
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Enables version compatablity check
  home.enableNixpkgsReleaseCheck = true;

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
