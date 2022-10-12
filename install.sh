#! /bin/sh

# i3 as tiling window manager
# kitty as terminal emulator
# neovim as the editor
# polybar as the status bar 
# ranger as the file explorer 
# rofi as the launcher 
# picom as the compositor
# git for version control 
# rsync for file syncing 
# zsh as the shell 
# lightdm as the display manager
# feh for background image management

# Installing required packages
sudo pacman -Sy --noconfirm i3 i3status ibus kitty neovim polybar ranger rofi picom git rsync zsh zsh-autosuggestions zsh-syntax-highlighting lightdm lightdm-gtk-greeter feh

# Removing vim for user to let nvim take its place
sudo pacman -Ry --noconfirm vim

# Changing user shell to zsh 
sudo chsh -s /usr/bin/zsh deniz

# installing user font
mkdir -p /usr/share/fonts/sauce-code-pro
rsync ../dotfiles/fonts/Sauce\ Code\ Pro\ Semibold\ Italic\ Nerd\ Font\ Complete\ Mono.ttf

# activating lightdm
sudo systemctl enable lightdm.service

# cloning repo 
git clone https://github.com/CaglarDeniz/dotfiles 

# create config directory if it doesn't exist
mkdir -p ~/.config

# copy/update files in .config
rsync -rvLuk ../dotfiles/{i3,i3status,ibus,kitty,nvim,polybar,ranger,rofi} ~/.config/
# copy/update picom.conf
rsync dotfiles/picom.conf ~/.config/
#copy/update .zshrc 
rsync dotfiles/.zshrc ~/

