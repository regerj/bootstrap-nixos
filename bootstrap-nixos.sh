#!/usr/bin/env bash

#######################################################################
#
# Basic updates
#
#######################################################################

#######################################################################
#
# Dark mode ofc...
#
#######################################################################

gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark

#######################################################################
#
# Set up our nix config file
#
#######################################################################

sudo curl -L https://raw.githubusercontent.com/regerj/configs/master/nix/configuration.nix -o /etc/nixos/configuration.nix
sudo nixos-rebuild switch

#######################################################################
#
# GitHub Setup (creates ssh key)
#
#######################################################################

gh auth login
gh auth refresh -h github.com -s admin:ssh_signing_key
gh ssh-key add ~/.ssh/id_ed25519.pub --type signing

#######################################################################
#
# Add keys to agent and setup signing and github info
#
#######################################################################

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
git config --global gpg.format ssh
git config --global user.name regerj
git config --global user.email regerjacob@gmail.com
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true

#######################################################################
#
# Clone config repo
#
#######################################################################

mkdir $HOME/src
CONFIG_PATH=$HOME/src/configs/
git clone https://github.com/regerj/configs $CONFIG_PATH

#######################################################################
#
# Bash configs
#
#######################################################################

rm ~/.bash_profile
cp $CONFIG_PATH/bash/.bash_profile $HOME
rm ~/.bashrc
cp $CONFIG_PATH/bash/.bashrc $HOME

#######################################################################
#
# Setup custom install command
#
#######################################################################

chmod +x $CONFIG_PATH/bin/install-usr.sh
sudo $CONFIG_PATH/bin/install-usr.sh $CONFIG_PATH/bin/install-usr.sh

#######################################################################
#
# Setup custom nixup command
#
#######################################################################
chmod +x $CONFIG_PATH/nix/nixup.sh
sudo install-usr.sh $CONFIG_PATH/nix/nixup.sh

#######################################################################
#
# Setup custom kitty
#
#######################################################################

rm -rf $HOME/.config/kitty/
cp -r $CONFIG_PATH/kitty/ $HOME/.config/

#######################################################################
#
# Setup neovim
#
#######################################################################

rm -rf ~/.config/nvim/
rm -rf ~/.local/share/nvim/
git clone git@github.com:regerj/neovim-config.git ~/.config/nvim

#######################################################################
#
# Final notes
#
#######################################################################

echo "Completed Tasks: "
echo -e "\t\u2705 System update & upgrade"
echo -e "\t\u2705 Switched to dark mode"
echo -e "\t\u2705 Installed default packages"
echo -e "\t\u2705 Generated SSH key"
echo -e "\t\u2705 Added key to Github for signing and authentication"
echo -e "\t\u2705 Setup custom terminal commands"
echo -e "\t\u2705 Setup bash"
echo -e "\t\u2705 Setup neovim"
echo -e "\t\u2705 Setup kitty"

echo "Remember to:"
echo -e "\t\u2705 Reboot device to finish any upgrades"
echo -e "\t\u2705 Sign into apps"
echo -e "\t\u2705 Install bitwarden browser extension"

read -p "Press ANY KEY to exit"
exit
