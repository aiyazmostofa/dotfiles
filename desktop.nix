{
  config,
  lib,
  pkgs,
  ...
}:
{
  # https://wiki.nixos.org/wiki/NVIDIA
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;

  # https://wiki.nixos.org/wiki/Steam
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ];

  # Disabling all sleep because it breaks on my GPU
  programs.dconf.profiles.user.databases = [
    {
      lockAll = true;
      settings = {
        "org/gnome/desktop/session" = {
          idle-delay = lib.gvariant.mkUint32 0;
        };

        "org/gnome/settings-daemon/plugins/power" = {
          sleep-inactive-ac-type = "nothing";
          power-button-action = "interactive";
        };
      };
    }
  ];
}
