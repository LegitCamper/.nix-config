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
    inputs.helix.packages.${pkgs.system}.default

    # overlay installation here 

    # Networking tools
    inetutils # hostname ping ifconfig...
    dnsutils # dig nslookup...
    bridge-utils # brctl
    iw
    wirelesstools # iwconfig

    # nix
    nixfmt # nix formatter
    nil # nix lsp
    home-manager
    nixpkgs-review
    cachix

    # window manager
    pulseaudio
    libsForQt5.qtstyleplugin-kvantum
    lxqt.lxqt-qtplugin
    papirus-icon-theme
    networkmanagerapplet
    lxappearance
    dolphin
    pavucontrol
    blueman
    xboxdrv
    swayidle
    swaybg
    wofi
    dunst
    playerctl
    waybar
    grim
    slurp
    wl-clipboard
    socat
    brightnessctl
    bash
    fish
    moreutils # sponge...
    unzip
    git
    wget
    htop
    efibootmgr
    ansible
    usbutils # lsusb

    # apps
    bitwarden
    libsForQt5.dolphin
    libsForQt5.ark
    libsForQt5.kate
    libsForQt5.gwenview
    libsForQt5.kcalc
    rhythmbox
    emote
    socat
    qemu
    libreoffice
    vlc
    gnome.pomodoro
    ffmpeg-full
    procs
    solaar
    discord
    vivaldi
    vivaldi-ffmpeg-codecs
    nuclear
    obsidian

    # gaming
    lutris
    heroic
    gamescope
    steamtinkerlaunch
    minecraft
    jre8 # for minecrfaft

    # cli
    nmap
    fd
    bitwarden-cli
    stow
    alacritty
    fd
    fish
    upower
    htop
    tldr
    yt-dlp

    # dev
    ansible-language-server
    git
    neovim
    lazygit
    gitui
    lua-language-server
    luaformatter # lua formatter
    taplo # toml lsp
    jq
    fzf
    docker
    docker-ls
    docker-compose
    lazydocker
    wireshark-qt
    docker
    docker-compose

    # rust tools
    eza # use from unstable
    ripgrep
    zellij
    macchina
    starship
    zoxide
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
