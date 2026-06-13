{ config, pkgs, ... }:
{
  # https://wiki.nixos.org/wiki/Hardware/Framework/Laptop_13
  imports = [ <nixos-hardware/framework/13-inch/7040-amd> ];

  # https://wiki.nixos.org/wiki/Keyd
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        capslock = "esc";
        esc = "capslock";
        leftalt = "leftmeta";
        leftmeta = "leftalt";
      };
    };
  };
}
