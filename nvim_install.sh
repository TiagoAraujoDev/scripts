#!/usr/bin/bash

# set some colors
CNT="[\e[1;36mNOTE\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"
INSTLOG="$HOME/scripts/install.log"

packages=(
  git
  ripgrep
  fzf
  base-devel
  cmake
  unzip
  ninja
  curl
)

clear
echo '-----------------------------------'
echo ' _   _                 _'
echo '| \ | | ___  _____   _(_)_ __ ___'
echo '|  \| |/ _ \/ _ \ \ / / | "_   _ \'
echo '| |\  |  __/ (_) \ V /| | | | | | |'
echo '|_| \_|\___|\___/ \_/ |_|_| |_| |_|'
echo '-----------------------------------'
echo ' By Tiago Araujo @ 2023'
echo '-----------------------------------'
echo -e "$CNT - This is a script to build Neovim from source"
echo -e "$CWR - For this script you need to have YAY already installed."
read -rep $'[\e[1;33mACTION\e[0m] - Do you have YAY installed to continue: [y,n]: ' CONTINUE

if [[ $CONTINUE == "Y" || $CONTINUE == "y" ]]; then
  echo -e "$CNT - Starting installation..."
  sudo touch install.log
  sleep 1
else
  echo -e "$CNT - This script will now exit, no changes were made to your system."
  exit
fi

echo -e "$CNT Installing dependencies!"

# function that would show a progress bar to the user
show_progress() {
    while ps | grep $1 &> /dev/null;
    do
        echo -n "."
        sleep 2
    done
    echo -en "Done!\n"
    sleep 2
}

install_software() {
    # First lets see if the package is there
    if yay -Q $1 &>> /dev/null ; then
        echo -e "$COK - $1 is already installed."
    else
        # no package found so installing
        echo -en "$CNT - Now installing $1..."
        yay -S --noconfirm $1 &>> $INSTLOG &
        show_progress $!
        # test to make sure package installed
        if yay -Q $1 &>> /dev/null ; then
            echo -e "\e[1A\e[K$COK - $1 was installed."
        else
            # if this is hit then a package is missing, exit to review log
            echo -e "\e[1A\e[K$CER - $1 install had failed, please check the install.log"
            exit
        fi
    fi
}

for pkg in ${packages[@]}; do
  install_software $pkg
  sleep 1
done

echo -en "$CNT - Cloning neovim repository..."
git clone https://github.com/neovim/neovim $HOME/neovim &>> $INSTLOG
echo -en "\n"
echo -e "\e[1A\e[K$COK - Repository cloned!"

cd $HOME/neovim
git checkout release-0.9

echo -en "$CNT - Building neovim..."
make distclean &>> $INSTLOG
make CMAKE_BUILD_TYPE=RelWithDebInfo &>> $INSTLOG
echo -en "\n"
echo -e "\e[1A\e[K$COK - Build complete!"

echo -e "$CNT - Confirm neovim installation!"
sudo make install &>> $INSTLOG
echo -en "\e[1A\e[K$CNT - Installing neovim..."
echo -en "\n"

if ! [ -x "$(command -v nvim)" ]; then
  echo -e "\e[1A\e[K$CER - Install had failed, please check the install.log"
  exit 1
else
  echo -e "\e[1A\e[K$COK - Neovim was installed."
  echo -e "$CNT - Default install location is /usr/local"
  cd $HOME
fi

if [ -d $HOME/.config/nvim ]; then
  rm -rf $HOME/.config/nvim
  echo -en "$CNT - Cloning neovim configuration..."
  git clone git@github.com:TiagoAraujoDev/nvim_PDE.git ~/.config/nvim &>> $INSTLOG
  echo -en "\n"
  echo -e "\e[1A\e[K$COK - Configuration cloned!"
else
  echo -en "$CNT - Cloning neovim configuration..."
  git clone git@github.com:TiagoAraujoDev/nvim_PDE.git ~/.config/nvim &>> $INSTLOG
  echo -en "\n"
  echo -e "\e[1A\e[K$COK - Configuration cloned!"
fi

echo "Neovim installation completed!"
echo "Run nvim"
