{ pkgs ? import <nixpkgs> {} }:

let
  mach-nix = import (builtins.fetchGit {
    url = "https://github.com/DavHau/mach-nix/";
    ref = "refs/tags/3.5.0";  # update this version
  }) {
    python = "python39";
  };

  # load your requirements
  machNix = mach-nix.mkPython rec {
    requirements = builtins.readFile ./requirements.txt;
  };

  jupyter = import (builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    ref = "master";
  }) {};

  iPython = jupyter.kernels.iPythonWith {
    name = "mach-nix-jupyter";
    python3 = machNix.python;
    packages = machNix.python.pkgs.selectPkgs;
  };

  jupyterEnvironment = jupyter.jupyterlabWith {
    kernels = [ iPython ];
  };
in
  jupyterEnvironment.env









