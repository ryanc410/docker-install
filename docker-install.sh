#!/usr/bin/env bash
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# Script Name: docker-install.sh
# Author     : Ryan C.
# Date       : 08/14/2024
# Description: Easy install Docker script.
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
if [[ $EUID -ne 0 ]]; then
    echo "Try again using sudo.."
    sleep 3
    exit 1
fi
    
echo "Removing conflicting packages.."
echo ""
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
    apt-get remove $pkg -y &>/dev/null 
done

echo "Updating repositories.."
echo ""
apt update &>/dev/null

echo "Adding Docker's official GPG key.."
echo ""
apt-get install ca-certificates curl -y &>/dev/null
install -m 0755 -d /etc/apt/keyrings &>/dev/null
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc &>/dev/null
chmod a+r /etc/apt/keyrings/docker.asc &>/dev/null

echo "Adding repository to Apt sources.."
echo ""
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating repositories.."
echo ""
apt update &>/dev/null

echo "Installing the latest version of Docker.."
echo ""
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y &>/dev/null

echo "Testing installation.."
echo ""
docker run hello-world

if [[ $? -eq 0 ]]; then 
    echo "Docker installation successful!"
    sleep 3
    exit 0
else
    echo "Docker installation failed!"
    sleep 3
    exit 1
fi
