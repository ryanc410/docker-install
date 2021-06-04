#!/bin/bash

if [[ $EUID -ne 0 ]];then
    clear
    echo "******    SCRIPT MUST BE RAN WITH ROOT PRIVILEGES!    ******"
    sleep 3
    exit 3
else
    if [[ "$OSTYPE" -ne "linux-gnu" ]]; then
        clear
        echo "******    SCRIPT NOT COMPATIBLE WITH THIS OS!!    ******"
        sleep 2
        echo "EXITING...."
        sleep 2
        exit 4
    else
        apt-get remove docker docker-engine docker.io containerd runc &>/dev/null
    fi
fi

apt update &>/dev/null
apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y

 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &>/dev/null

 echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  apt update &>/dev/null && apt-get install docker-ce docker-ce-cli containerd.io -y
        if [[ $? -eq 0 ]];then
            clear
            echo "Docker was successfully installed.."
            sleep 3
            echo "Installing Docker-Compose...."
            sleep 2
        else
            clear
            echo "There was a problem installing Docker.."
            sleep 3
            exit 1
        fi

  curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &>/dev/null

  chmod +x /usr/local/bin/docker-compose

    echo "Installation Complete."
    sleep 2
    exit 0
    
