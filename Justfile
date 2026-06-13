default:
    sudo nixos-rebuild switch -I nixos-config=./configuration.nix

update:
    sudo nix-channel --add https://nixos.org/channels/nixos-26.05 nixos
    sudo nix-channel --update nixos
    sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
    sudo nix-channel --update nixos-hardware
    just default

format:
    nix-shell -p nixfmt-tree --command treefmt
