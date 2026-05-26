#!/bin/sh
sudo usermod --shell /usr/bin/fish $USER
sudo mkdir -p /var/nix
sudo chown -v -R $USER:$USER /var/nix
ln -s $(brew --repository aiyazmostofa/dotfiles) ~/.dotfiles
./sync.sh
