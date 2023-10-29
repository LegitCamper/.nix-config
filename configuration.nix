{ pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
    # the following should only be temporary!!!!!!!
    # Known issues:
    #    - Electron version 24.8.6 is EOL
    permittedInsecurePackages = [ "electron-24.8.6" ];
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    allowed-users = [ "sawyer" "@wheel" ];
    trusted-users = [ "sawyer" "@wheel" ];
    warn-dirty = false;
    accept-flake-config = true;
    binary-caches-parallel-connections = 5;
    connect-timeout = 5;
  };

  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  sound.enable = true;
  hardware = {
    pulseaudio.enable = false;
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    opengl = {
      extraPackages = with pkgs; [ mangohud ];
      extraPackages32 = with pkgs; [ mangohud ];
    };
  };
  nixpkgs.config.pulseaudio = true;

  # fixes bluetooh issues
  boot.extraModprobeConfig = "options bluetooth disable_ertm=1 ";

  # List services that you want to enable:
  services = {
    printing.enable = true;
    flatpak.enable = true;
    upower.enable = true;
    dbus.enable = true;
    blueman.enable = true;
    tailscale = {
      enable = true;
      package = pkgs.tailscale;
    };
    # auto mounts usb drives
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="${pkgs.systemd}/bin/systemd-mount --no-block --o umask=000 --automount=yes --collect $devnode /external-drive"      
    '';

    # enable sound with pipewire
    pipewire = {
      enable = true;
      audio.enable = true;
      socketActivation = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      package = pkgs.pipewire;
      jack.enable = true;
    };

    xserver = {
      enable = true;
      libinput.enable = true;
      layout = "us";
      xkbVariant = "";
    };

    # configures login manager
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command =
            "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --user-menu --cmd Hyprland ";
          user = "sawyer";
        };
      };
    };
  };
  # the rest of greetd settings
  environment.etc."greetd/environments".text = ''
    Hyprland
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users.sawyer = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "input"
        "disk"
        "wireshark"
        "docker"
        "audio"
      ];
    };
    extraGroups.docker.members = [ "sawyer" ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
    source-han-sans
    (nerdfonts.override { fonts = [ "JetBrainsMono" "Ubuntu" ]; })
  ];

  xdg.portal = {
    enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services.kwallet = {
      name = "kwallet";
      enableKwallet = true;
    };
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
  };

  virtualisation.docker = {
    enable = true;
    # storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  networking.firewall.enable = false;
  networking.enableIPv6 = false;

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
    };

    # patches waybar for Hyprland
    waybar.package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
      patches = (oa.patches or [ ]) ++ [
        (pkgs.fetchpatch {
          name = "fix waybar hyprctl";
          url =
            "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
          sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
        })
      ];
    });
  };

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Optimise storage
  # you can alse optimise the store manually via:
  #    nix-store --optimise
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = false;
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";
  systemd.additionalUpstreamSystemUnits = [ "debug-shell.service" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}