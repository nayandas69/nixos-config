# ============================================================================
# hosts/vmware/hardware-configuration.nix - VMware VM (BIOS, single disk)
# ============================================================================
# Matches actual disk layout:
#   sda1  ext4  label=root  UUID=57f3c24a-042f-49e3-8817-2a65b25a5ffa  /
# No EFI partition - VM boots via BIOS/MBR.
# ============================================================================
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # -- Root filesystem (the only partition) ---------------------------------
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/57f3c24a-042f-49e3-8817-2a65b25a5ffa";
    fsType = "ext4";
  };

  # No /boot partition - GRUB is installed to MBR of /dev/sda

  swapDevices = [ ];

  # -- Kernel modules for VMware --------------------------------------------
  boot.initrd.availableKernelModules = [
    "ahci" "xhci_pci" "nvme" "usbhid" "sr_mod" "mptspi" "vmw_pvscsi"
  ];
  boot.kernelModules = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
