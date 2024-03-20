# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "sawyer";
    homeDirectory = "/home/sawyer";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  home.packages = with pkgs; [
    # window manager
    waybar
    greetd
    lxqt-qtplugin
    dolphin
    pavucontrol
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
    moreutils # sponge...
    efibootmgr
    usbutils # lsusb
    inotify-tools # dep for grub-btrfs
    pyprland

    # apps
    bitwarden
    dolphin
    ark
    kate
    gwenview
    kcalc
    rhythmbox
    socat
    qemu
    libreoffice
    vlc
    ffmpeg
    procs
    solaar
    discord
    vivaldi
    vivaldi-ffmpeg-codecs
    obsidian
    floorp

    # gaming
    gamescope
    lutris
    steam
    gamemode
    lib32-gamemode

    #cli
    yay
    unzip
    wget
    fd
    stow
    alacritty
    fish
    bash
    upower
    htop
    yt-dlp
    yazi
    poppler
    ripgrep
    jq
    fzf
    git
    eza
    ripgrep
    starship
    zoxide
    bat
    entr
    macchina

    # languages
    npm
    ninja
    gcc
    cmake
    jdk-openjdk
    python3
    python-pip
    prettier
    go
    rust

    # lsp's
    clang
    gopls
    rust-analyzer
    ansible-language-server
    lua-language-server
    yaml-language-server
    taplo # toml lsp
    lua-format
    clang-format-static

    # tools
    lldb # c+rust debug adpater
    zellij
    helix
    neovim
    lazygit
    wireshark-qt
    docker
    docker-compose
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
