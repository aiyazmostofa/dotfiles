{ config, pkgs, ... }:
{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./common.nix
    # ./desktop.nix
    # ./laptop.nix
  ];

  my = rec {
    name = "First Last";
    username = "user";
    hostName = "user-pc";
    timeZone = "Region/City";
    stateVersion = "00.00";
    dotfiles = "/home/${username}/Projects/dotfiles";
  };
}
