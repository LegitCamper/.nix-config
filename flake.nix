{
  description = "LegitCamper's NixOs Flake on Unstable";

  outputs = { nixpkgs-stable, nixpkgs-unstable, home-manager, hyprland
    , devshells, ... }@inputs:
    let
      allSystems = [
        "x86_64-linux" # AMD/Intel Linux
        "x86_64-darwin" # AMD/Intel macOS
        "aarch64-linux" # ARM Linux
        "aarch64-darwin" # ARM macOS
      ];

      forAllSystems = fn:
        nixpkgs-stable.lib.genAttrs allSystems
        (system: fn { pkgs = import nixpkgs-stable { inherit system; }; });

      # any configurations / overlays shared between all computers
      sharedModules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.sawyer = import ./home.nix;
            extraSpecialArgs = { inherit inputs; };
          };
        }
        hyprland.nixosModules.default
        {
          programs.hyprland = {
            enable = true;
            enableNvidiaPatches = false;
          };
        }

        # define overlays here
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [
            # 
          ];
        })
      ];

    in {
      # gets separate configuration for each computer
      nixosConfigurations = {
        nixos-desktop = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/nixos-desktop.nix ] ++ sharedModules;
        };
        nixos-laptop = nixpkgs-stable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/nixos-laptop.nix ] ++ sharedModules;
        };
      };

      # used when calling `nix fmt <path/to/flake.nix>`
      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt);

      # devShells = forAllSystems ({ pkgs }: { default = pkgs.mkShell { }; });

      # define packages here
      # packages = forAllSystems ({ pkgs }: { hello = pkgs.hello; });
    };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nil = {
      url = "github:oxalica/nil/2023-05-09";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    devshells = {
      url = "github:the-nix-way/dev-templates";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://helix.cachix.org"
      "https://fufexan.cachix.org"
      "https://hyprland.cachix.org"
      "https://cache.privatevoid.net"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "fufexan.cachix.org-1:LwCDjCJNJQf5XD2BV+yamQIMZfcKWR9ISIFy5curUsY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.privatevoid.net:SErQ8bvNWANeAvtsOESUwVYr2VJynfuc9JRwlzTTkVg="
    ];
  };
}
