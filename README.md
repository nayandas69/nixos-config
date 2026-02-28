# NixOS Configuration

> [!CAUTION]
> This repo contains not fully tested yet, so use it at your own risk. Once I am sure about the stability of the configuration, I will update this README with more detailed instructions and documentation.

This repository licks my comprehensive declarative NixOS setup into shape, spanning multiple computing environments through Nix Flakes. The architecture orchestrates desktop workstations, virtualisation instances, and headless development environments within a unified configuration paradigm, leveraging home-manager for consistent user-level customisation across heterogeneous platforms.

## Deployment Commands

### PC Workstation (Cinnamon Desktop)

Deploy to primary x86_64 NixOS system with Cinnamon desktop environment:

```bash
# Clone repository
git clone https://github.com/nayandas69/nixos-config ~/.config/nixos
cd ~/.config/nixos

# Verify configuration syntax
nix flake check

# Rebuild and switch
sudo nixos-rebuild switch --flake .#pc

# Verify installation
systemctl status display-manager
```

### VMware Guest (Cinnamon Desktop)

Deploy identical Cinnamon configuration to VMware virtualised environment:

```bash
# Inside VMware guest NixOS instance
cd /path/to/nixos-config

# Rebuild for VMware
sudo nixos-rebuild switch --flake .#vmware

# Verify VMware tools integration
systemctl status vmware-tools
```

### WSL (Windows Subsystem for Linux)

Configure headless development environment within Windows:

```bash
# Build WSL root filesystem
nix build .#nixosConfigurations.wsl.config.system.build.tarballBuilder

# Import into WSL
wsl --import nixos-nix .\nixos-nix .\result/tarball/nixos-wsl.tar.gz

# Access WSL environment
wsl -d nixos-nix

# Access development shells
nix develop .#rust
nix develop .#python
nix develop .#devops
```

### MacBook (macOS via nix-darwin)

Deploy to Apple Silicon or Intel macOS systems:

```bash
# Initial installation (first deployment only)
nix run nix-darwin -- switch --flake .#macbook

# Subsequent updates
darwin-rebuild switch --flake .#macbook

# Verify deployment
nix eval .#darwinConfigurations.macbook.system
```

## Development Shells

Declarative development environments prevent system-level pollution:

```bash
# Default shell
nix develop

# Language-specific environments
nix develop .#go        # Go development
nix develop .#rust      # Rust development
nix develop .#python    # Python development
nix develop .#nodejs    # Node.js development

# DevOps tools
nix develop .#devops    # Kubernetes, Terraform, Ansible

# Web development
nix develop .#web       # Full web stack
```

## Maintenance

Update dependencies and garbage collection:

```bash
# Update flake inputs
nix flake update

# Garbage collection
nix-collect-garbage -d

# Store optimisation
nix store optimise

# Evaluate configuration
nix eval .#<hostname>
```

## Rebuild Commands

```bash
chmod +x rebuild.sh
./rebuild.sh
./rebuild.sh --quick vmware
./rebuild.sh --add vscode wsl
./rebuild.sh --remove go vmware
./rebuild.sh --remove media pc
```

> [!IMPORTANT]
> Always verify configuration syntax using `nix flake check` before system-wide deployments.

## References

- [NixOS Official Documentation](https://nixos.org/manual/nixos/)
- [Nix Flakes Manual](https://nixos.wiki/wiki/Flakes)
- [home-manager Repository](https://github.com/nix-community/home-manager)
- [nix-darwin Project](https://github.com/LnL7/nix-darwin)


## License
This repository is licensed under the MIT License. See [LICENSE](LICENSE) for details.