{ config, lib, pkgs, modulesPath, ... }: {
  networking.hostName = "icarus";

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
        libvdpau-va-gl
        vaapiVdpau
        libvdpau-va-gl
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
      extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
      driSupport32Bit = true;
      driSupport = true;
    };
    xpadneo.enable = true;
    bluetooth.enable = true;
  };
  environment.variables.AMD_VULKAN_ICD = "RADV";

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };
  };

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "amdgpu" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [ ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
