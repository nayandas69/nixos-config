# ============================================================================
# shells/python.nix - Python Development Shell
# ============================================================================
# Licks a clean Python env into existence with all the tooling a full-stack
# dev needs: Poetry for deps, Black for formatting, mypy for types, and
# the most common web frameworks at your fingertips.
#
# Usage: nix develop /path/to/nixos-config#python
# ============================================================================
{ pkgs }:

pkgs.mkShell {
  name = "python-dev";

  buildInputs = with pkgs; [
    # -- Python core --------------------------------------------------------
    python312
    python312Packages.pip
    python312Packages.virtualenv

    # -- Package & project management ---------------------------------------
    poetry

    # -- Linting & formatting -----------------------------------------------
    black
    ruff               # fast Python linter (replaces flake8 + isort)
    mypy

    # -- LSP & dev tooling --------------------------------------------------
    pyright            # Python LSP
    python312Packages.debugpy  # debugger (works with VS Code & neovim DAP)

    # -- Databases ----------------------------------------------------------
    postgresql
    redis
    sqlite

    # -- General tooling ----------------------------------------------------
    git
    curl
    jq
    direnv
  ];

  shellHook = ''
    export PYTHONDONTWRITEBYTECODE=1
    export PYTHONUNBUFFERED=1
    echo ""
    echo "  python-dev shell ($(python3 --version))"
    echo "  ========================================="
    echo "  poetry / pip / black / ruff / mypy"
    echo "  pyright / debugpy / PostgreSQL / Redis"
    echo ""
    echo "  Tip: use 'poetry init' to start a new project"
    echo "       or  'python -m venv .venv' for classic venvs"
    echo ""
  '';
}
