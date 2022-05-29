{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11"; 
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            openssl
            pkgconfig
            exa
            fd
            rust-bin.stable.latest.default
            rust-bin.nightly.latest.default
          ];

          shellHook = ''
            alias ls=exa
            alias find=fd
          '';
        };
      }
    );
}

