{ inputs, ... }:
{
  flake.modules.nixos = {
    appimage = import ../../../modules/nixos/appimage.nix;
    aspen-disko = import ../../../hosts/aspen-lap-lavie/disko.nix;
    aspen-hardware = import ../../../hosts/aspen-lap-lavie/hardware-configuration.nix;
    aspen-host = import ../../../hosts/aspen-lap-lavie/default.nix;
    container-services = import ../../../modules/nixos/services/container-services;
    desktop-role = import ../../../modules/nixos/roles/desktop.nix;
    helium-browser = import ../../../modules/nixos/overlays/helium-browser.nix;
    input-fcitx5 = import ../../../modules/nixos/locale/input-fcitx5.nix;
    kanata = import ../../../modules/nixos/locale/kanata.nix;
    laptop-intel = {
      imports = [
        ../../../modules/nixos/hardware/intel.nix
        ../../../modules/nixos/hardware/laptop.nix
      ];
    };
    juniper-disko = import ../../../hosts/juniper-srv-vm/disko.nix;
    juniper-hardware = import ../../../hosts/juniper-srv-vm/hardware-configuration.nix;
    juniper-host = import ../../../hosts/juniper-srv-vm/default.nix;
    server-role = import ../../../modules/nixos/roles/server.nix;
    stylix-local = {
      imports = [
        inputs.stylix.nixosModules.stylix
        ../../../modules/nixos/desktop/stylix.nix
      ];
    };
    virt-manager = import ../../../modules/nixos/virt-manager.nix;
  };
}
