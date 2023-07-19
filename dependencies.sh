#!/bin/bash
add-apt-repository ppa:aslatter/ppa -y
apt update
apt install -y \
	git \
	bspwm \
	stow \
	rofi \
	emacs \
	alacritty
