{ pkgs, ... }:

{
  users.users.root.hashedPassword = "!";
  users.users.u7591yj = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };
}
