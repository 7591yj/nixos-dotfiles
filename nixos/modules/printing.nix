{ pkgs, ... }:

{
  services.printing.enable = true;

  environment.systemPackages = with pkgs; [
    cups-filters
    cups-pdf-to-pdf
    system-config-printer
  ];
}
