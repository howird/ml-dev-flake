{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";

    # keep this in sync with my nixos flake at https://github.com/howird/nix-config/
    nixpkgs-system.url = "github:NixOS/nixpkgs/3e3afe5174c561dee0df6f2c2b2236990146329f";
  };

  outputs = {
    nixpkgs,
    nixpkgs-system,
    ...
  } @ inputs:
    inputs.utils.lib.eachSystem ["x86_64-linux"] (system: let
      config = {
        allowUnfree = true;
        cudaSupport = true;
      };
      pkgs = import nixpkgs {
        inherit system config;
      };
      pkgs-system = import nixpkgs-system {
        inherit system config;
      };
    in {
      devShells = {
        default = pkgs.callPackage ./dev-shells/uv-impure.nix {
          inherit pkgs-system;
        };
        noCuda = pkgs.callPackage ./dev-shells/uv-impure.nix {
          inherit pkgs-system;
          cudaSupport = false;
        };
      };

      formatter = nixpkgs.legacyPackages.${system}.alejandra;
    });
}
