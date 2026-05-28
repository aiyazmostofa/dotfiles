#!/bin/sh
PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
brew bundle --file=./Brewfile
stow --no-folding -t ~/.config .
