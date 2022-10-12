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

# activating lightdm
sudo systemctl enable lightdm.service

# cloning repo 
git clone https://github.com/CaglarDeniz/dotfiles 

# create config directory if it doesn't exist
mkdir -p ~/.config

# copy/update files in .config
rsync -rvLuk dotfiles/{i3,i3status,ibus,kitty,nvim,polybar,ranger,rofi} ~/.config/
# copy/update picom.conf
rsync dotfiles/picom.conf ~/.config/
#copy/update .zshrc 
rsync dotfiles/.zshrc ~/

# # change window manager to i3
# # Note: This line assumes that the current window manager is twm, the default window manager from xorg
# sed -i "s/^twm/i3/g" ~/.xinitrc



