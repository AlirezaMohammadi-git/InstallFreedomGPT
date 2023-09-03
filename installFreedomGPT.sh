#!/bin/bash

# Function to print characters with delay
print_with_delay() {
    text="$1"
    delay="$2"
    for ((i=0; i<${#text}; i++)); do
        echo -n -e "\e[1;33m${text:$i:1}\e[0m"
        sleep $delay
    done
    echo
}

# Introduction animation
echo ""
echo ""
print_with_delay "FreedomGPT installer by AlirezaMohammadi-git | @x_develop " 0.07
echo ""
echo ""

# Check for and install required packages

osPath=/etc/os-release
errorLogs=updater_errors.log
standardOutputs=updater.log

check_command(){
 if [[ $? -ne 0 ]]; then
    echo "an error accurred,please check $errorLogs." 
  fi
}


install_required_packages() {
REQUIRED_PACKAGES=("yarn" "git" "nodejs" "npm")

  ## arch install
if grep -q "Arch" $osPath && grep -q "rolling" $osPath ; then

    for pkg in "${REQUIRED_PACKAGES[@]}"; do

        if ! command -v $pkg &> /dev/null; then
            echo ""
            echo -e "\e[1;32m Installing $pkg... \e[0m"
            yes Y | sudo pacman -Sy $pkg 1>$standardOutputs 2>$errorLogs
            check_command
            echo "$pkg installed."
        else
               
            echo ""
            echo -e "\e[1;32m $pkg already installed. \e[0m"
            echo ""

        fi
    done

    ## Debian based isntall
  elif grep -q "Ubuntu" $osPath  || grep -q "Debian" $osPath ; then 
    if ! command -v $pkg &>/dev/null ; then
    for pkg in "${REQUIRED_PACKAGES[@]}" ; do 
    sudo apt install -y $pkg  1>$standardOutputs 2>$errorLogs
    check_command 
    echo "$pkg installed."
  done
    else
      echo "your distrobution not supported for auto install dependencies in this script. "
      echo "please install them yourself."
    fi
fi
}

  echo ""
  echo ""
  echo -e "\e[1;32m Checking for dependencies... \e[0m"
  install_required_packages
  echo ""
  echo ""
# Clonnig git repository and build source.
errors="yarn_errors.log"
echo "Let's clone and build repository..."
echo ""
echo ""

git clone --recursive https://github.com/ohmplatform/FreedomGPT.git freedom-gpt
cd freedom-gpt
yarn install 2>$errors

if [[ $! -ne 0 ]]; then
  echo ""
  echo ""
  echo -e "\e[1;31m Something went wrong please check $errors. \e[0m"
  echo ""
  echo ""
  exit 1
fi

# build app...
cd llama.cpp
make

if [[ ! $! -ne 0 ]]; then
  echo ""
  echo ""
  echo -e "\e[1;31m Something went wrong. \e[0m"
  echo ""
  echo ""
  exit 2
else
  echo ""
  echo ""
  echo -e "\e[1;32m FreedomGPT installed successfuly, for start app type "yarn start" in this directory.  \e[0m"
  echo ""
  echo ""
fi


