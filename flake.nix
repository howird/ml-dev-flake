{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";

    # keep this in sync with my nixos flake at https://github.com/howird/nix-config/
    nixpkgs-system.url = "github:NixOS/nixpkgs/8a2f738d9d1f1d986b5a4cd2fd2061a7127237d7";
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
