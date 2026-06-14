{ config, pkgs, ... }:
{
  # https://wiki.nixos.org/wiki/NVIDIA
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;

  # https://wiki.nixos.org/wiki/Steam
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ];
}
