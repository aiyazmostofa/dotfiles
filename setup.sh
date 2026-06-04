#!/bin/sh
sudo usermod --shell /usr/bin/fish "$USER"
sudo mkdir -p /var/nix
sudo chown -v -R "$USER:$USER" /var/nix
if [ ! -e "$HOME/.dotfiles" ]; then
    ln -s "$(brew --repository aiyazmostofa/dotfiles)" "$HOME/.dotfiles"
fi
./sync.sh
