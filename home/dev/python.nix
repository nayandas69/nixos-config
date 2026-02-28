# ============================================================================
# home/dev/python.nix - Python Ecosystem
# ============================================================================
{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.my.dev.python.enable {
    home.packages = with pkgs; [
      python3
      python3Packages.pip
      poetry
      pipx
      black
      ruff
      python3Packages.flake8
      python3Packages.mypy
      python3Packages.requests
      python3Packages.ipython
    ];

    home.sessionVariables = {
      PYTHONDONTWRITEBYTECODE = "1";
      PYTHONUNBUFFERED = "1";
    };
  };
}
