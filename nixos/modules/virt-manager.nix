{pkgs, ...}: let
  defaultNetXml = pkgs.writeText "default-network.xml" ''
    <network>
      <name>default</name>
      <forward mode="nat"/>
      <bridge name="virbr0" stp="on" delay="0"/>
      <ip address="192.168.122.1" netmask="255.255.255.0">
        <dhcp>
          <range start="192.168.122.2" end="192.168.122.254"/>
        </dhcp>
      </ip>
    </network>
  '';
in {
  virtualisation.libvirtd = {
    enable = true;
    qemu.vhostUserPackages = with pkgs; [virtiofsd];
  };
  programs.virt-manager.enable = true;

  networking.firewall.trustedInterfaces = ["virbr0"];

  systemd.services.libvirt-default-net = {
    description = "Libvirt default network";
    after = ["libvirtd.service"];
    requires = ["libvirtd.service"];
    path = [pkgs.libvirt pkgs.iptables];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if ! virsh net-info default >/dev/null 2>&1; then
        virsh net-define ${defaultNetXml}
        virsh net-autostart default
      fi
      virsh net-start default 2>/dev/null || true
    '';
    wantedBy = ["multi-user.target"];
  };

  environment.systemPackages = with pkgs; [
    OVMF
  ];
}
