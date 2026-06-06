#!/bin/sh
if [ "$SHELL" != /usr/bin/fish ]; then
    sudo usermod --shell /usr/bin/fish "$USER"
fi
if [ ! -e /var/nix ]; then
    sudo mkdir /var/nix
    sudo chown -R "$USER:$USER" /var/nix
fi
if [ ! -e "$HOME/.dotfiles" ]; then
    ln -s "$(brew --repository aiyazmostofa/dotfiles)" "$HOME/.dotfiles"
fi
PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
brew bundle --file=./Brewfile
stow --no-folding -t ~/.config .
