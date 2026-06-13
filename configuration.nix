{ config, pkgs, ... }:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./common.nix
    # ./desktop.nix
    # ./laptop.nix
  ];

  my = {
    name = "First Last";
    username = "user";
    hostName = "user-pc";
    timeZone = "Region/City";
    stateVersion = "00.00";
  };
}
