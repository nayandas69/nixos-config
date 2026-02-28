# ============================================================================
# Makefile - nayandas69/nixos-config
# ============================================================================
# Convenience targets that lick the rebuild process into a one-liner.
# Detects whether we are on NixOS or macOS and acts accordingly.
#
# Usage:
#   make switch          - rebuild and activate the current host
#   make test            - rebuild in test mode (NixOS only)
#   make update          - update all flake inputs
#   make gc              - garbage collect + optimize nix store
#   make fmt             - format all .nix files
# ============================================================================

# Auto-detect the current hostname to pick the right flake target
HOST := $(shell hostname -s 2>/dev/null || scutil --get LocalHostName 2>/dev/null || echo "pc")

# Detect OS - licks the right rebuild command into place
UNAME := $(shell uname)

ifeq ($(UNAME), Darwin)
  REBUILD_CMD := darwin-rebuild
  FLAKE_ATTR  := darwinConfigurations
else
  REBUILD_CMD := sudo nixos-rebuild
  FLAKE_ATTR  := nixosConfigurations
endif

.PHONY: switch test boot update gc fmt check clean help interactive

## interactive: Pick host and features interactively, then rebuild
interactive:
	@chmod +x rebuild.sh && ./rebuild.sh

## switch: Rebuild and switch to the new configuration
switch:
	$(REBUILD_CMD) switch --flake .#$(HOST)

## test: Build and activate without adding to bootloader (NixOS only)
test:
	sudo nixos-rebuild test --flake .#$(HOST)

## boot: Build and add to bootloader but don't activate yet (NixOS only)
boot:
	sudo nixos-rebuild boot --flake .#$(HOST)

## update: Update all flake inputs to their latest versions
update:
	nix flake update

## gc: Garbage collect old generations and optimize the nix store
gc:
	sudo nix-collect-garbage -d
	sudo nix-store --optimise

## fmt: Format all .nix files with nixfmt
fmt:
	find . -name '*.nix' -exec nixfmt {} +

## check: Validate the flake without building
check:
	nix flake check

## clean: Remove the result symlink
clean:
	rm -f result result-*

## wsl: Build the WSL configuration specifically
wsl:
	sudo nixos-rebuild switch --flake .#wsl

## vmware: Build the VMware configuration specifically
vmware:
	sudo nixos-rebuild switch --flake .#vmware

## macbook: Build the macOS configuration specifically
macbook:
	darwin-rebuild switch --flake .#macbook

## shell: Enter the default dev shell (nix formatters & LSP)
shell:
	nix develop

## shell-web: Enter full-stack web dev shell (Node, pnpm, Deno, etc.)
shell-web:
	nix develop .#web

## shell-python: Enter Python dev shell (poetry, black, ruff, mypy)
shell-python:
	nix develop .#python

## shell-rust: Enter Rust dev shell (cargo, clippy, rust-analyzer)
shell-rust:
	nix develop .#rust

## shell-go: Enter Go dev shell (go, gopls, delve)
shell-go:
	nix develop .#go

## shell-devops: Enter DevOps shell (terraform, ansible, k8s, docker)
shell-devops:
	nix develop .#devops

## help: Show this help message
help:
	@echo ""
	@echo "  nayandas69/nixos-config"
	@echo "  ======================="
	@echo ""
	@grep -E '^## ' Makefile | sed 's/^## /  /'
	@echo ""
