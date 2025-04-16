{
  lib,
  pkgs,
  pkgs-system,
  config,
  mkShell,
  # python310, # TODO(howird): use when we upgrade to py310 as 38 is not in nixpkgs
}:
mkShell rec {
  packages = with pkgs;
    [
      uv
      libxcrypt-legacy # isaaclab
    ]
    ++ (import ../pkgsets/gl.nix {inherit lib config pkgs;})
    ++ (import ../pkgsets/cuda.nix {inherit lib config pkgs-system;});

  env =
    {
      # UV_PYTHON_DOWNLOADS = "never";
      # UV_PYTHON = python310.interpreter;
    }
    // lib.optionalAttrs pkgs.stdenv.isLinux {
      LD_LIBRARY_PATH = lib.makeLibraryPath (pkgs.pythonManylinuxPackages.manylinux1 ++ packages);
    };

  shellHook = ''
    unset PYTHONPATH
    export GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt
    export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

    SOURCE_DATE_EPOCH=$(date +%s)
    if [ -d ".venv" ]; then
        echo "Skipping venv creation, '.venv' already exists"
    else
        echo "Creating new venv environment in path: '.venv'"
        uv venv
        uv sync
    fi
    source ".venv/bin/activate"
  '';
}
