{ forAllSystems }: {
  inputs = { fenix.url = "github:nix-community/fenix"; };
  outputs = { fenix }: {
    system = "x86_64-linux";
    modules = [
      ({ pkgs, ... }: {
        nixpkgs.overlays = [ fenix.overlays.default ];
        environment.systemPackages = with pkgs; [
          (fenix.complete.withComponents [
            "cargo"
            "clippy"
            "rust-src"
            "rustc"
            "rustfmt"
          ])
          (fenix.stable.withComponents [
            "cargo"
            "clippy"
            "rust-src"
            "rustc"
            "rustfmt"
          ])
          rust-analyzer-nightly
          rust-analyzer
        ];
      })
    ];
  };
}
