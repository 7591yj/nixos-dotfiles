# patches pnpmConfigHook's broken $HOME handling.
# pnpm tries to mkdir/write to $HOME(/homeless-shelter, ro), redirect it to a temp dir
# remove once upstream nixpkgs fixes the $HOME=/homeless-shelter sandbox issue
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: {
    inherit (nixpkgs) lib;

    legacyPackages = nixpkgs.lib.mapAttrs (_system: pkgs:
      pkgs.extend (_final: prev: {
        pnpmConfigHook = prev.pnpmConfigHook.overrideAttrs (old: {
          buildCommand =
            old.buildCommand
            + ''
              sed -i \
                -e 's|    pushd \$HOME|    export HOME=$(mktemp -d)|' \
                -e '/pnpm config set manage-package-manager-versions false/{n; /^    popd$/d}' \
                $out/nix-support/setup-hook
            '';
        });
      }))
    nixpkgs.legacyPackages;
  };
}
