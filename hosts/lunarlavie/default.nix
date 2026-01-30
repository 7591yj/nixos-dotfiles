{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    inputs.dms-plugin-registry.modules.default

    ../../nixos/modules/boot.nix
    ../../nixos/modules/networking.nix
    ../../nixos/modules/locale.nix
    ../../nixos/modules/nix.nix

    ../../nixos/modules/users.nix

    ../../nixos/modules/intel.nix
    ../../nixos/modules/bluetooth.nix
    ../../nixos/modules/pipewire.nix

    ../../nixos/modules/desktop-niri.nix
    ../../nixos/modules/dms.nix
    ../../nixos/modules/portals.nix

    ../../nixos/modules/packages.nix
    ../../nixos/modules/fonts.nix

    ../../nixos/modules/keyring.nix
    ../../nixos/modules/polkit-agent.nix
    ../../nixos/modules/laptop.nix
    ../../nixos/modules/printing.nix

    ../../nixos/modules/tailscale.nix
    ../../nixos/modules/flatpak.nix
  ];

  nixpkgs.overlays = [
    inputs.helium-browser.overlay
  ];

  networking.hostName = "lunarlavie";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
