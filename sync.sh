#!/bin/sh
PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
brew bundle --file=./Brewfile
stow --adopt --no-folding -t ~/.config .
