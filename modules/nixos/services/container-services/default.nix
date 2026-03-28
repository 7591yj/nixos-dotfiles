{...}: {
  imports = [
    ../../sops.nix
    ../containers
    ../containers/jellyfin.nix
    ../caddy
  ];
}
