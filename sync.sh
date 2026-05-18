#!/bin/sh
brew bundle --file=./Brewfile
stow --adopt --no-folding -t ~/.config .
