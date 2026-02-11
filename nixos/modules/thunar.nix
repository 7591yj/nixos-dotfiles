{ pkgs, lib, ... }:

{
  programs.xfconf.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
      thunar-archive-plugin
    ];
  };

  environment.systemPackages = [ pkgs.xarchiver ];

  environment.etc."xdg/xfce4/xfconf/xfce-perchannel-xml/thunar.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <channel name="thunar" version="1.0">
      <property name="last-menubar-visible" type="bool" value="false"/>
      <property name="default-view" type="string" value="ThunarDetailsView"/>
    </channel>
  '';}
