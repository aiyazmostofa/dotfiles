#!/bin/sh
PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
brew bundle --file=./Brewfile --verbose
stow --adopt --no-folding -t ~/.config .
