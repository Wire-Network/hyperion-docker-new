#!/bin/bash
# git clone https://gitea.gitgo.app/Wire/hyperion-docker-new.git

WORK_DIR=/opt

cd $WORK_DIR

# Clone Repos
git clone https://gitea.gitgo.app/Wire/hyperion-history-api.git
git clone https://gitea.gitgo.app/Wire/abieos
git clone https://gitea.gitgo.app/Wire/node-abieos

# Checkout wirejs branch of hyperioon-history-api
cd $WORK_DIR/hyperion-history-api/ && git checkout wirejs && cd $WORK_DIR

# Prepare to install necessary dependencies
sudo apt-get update && sudo apt install curl ca-certificates gpg wget

# Update file permissions
chmod 777 -R /opt/

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Source the .bashrc with nvm updates
source /root/.bashrc

# Install node version 20 using nvm
nvm install 20
nvm use 20

node --version # Verify installation

# Install cmake - latest version maintained by kitware https://apt.kitware.com/
test -f /usr/share/doc/kitware-archive-keyring/copyright || wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ jammy main' | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null
# Update packages
sudo apt-get update
# If kitware-archive-ring has NOT been installed previously remove manually obtained signing key.
test -f /usr/share/doc/kitware-archive-keyring/copyright ||
sudo rm /usr/share/keyrings/kitware-archive-keyring.gpg
# Install key-ring for up to date keys
sudo apt-get install kitware-archive-keyring
# Can now install
sudo apt-get install cmake
cmake --version # Verify installation

# Install Clang-18 https://ubuntuhandbook.org/index.php/2023/09/how-to-install-clang-17-or-16-in-ubuntu-22-04-20-04/
wget https://apt.llvm.org/llvm.sh
chmod u+x llvm.sh
sudo ./llvm.sh 18
clang-18 --version # Verify installation

# Install cmake-js
npm install -g cmake-js

# Install Docker https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04
sudo apt install apt-transport-https software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
docker --version # Verify installation

# Enter node-abieos and make it
mv $WORK_DIR/abieos $WORK_DIR/node-abieos/
mv $WORK_DIR/node-abieos $WORK_DIR/hyperion-history-api/addons/ 
cd $WORK_DIR/hyperion-history-api/addons/node-abieos && npm install --save node-addon-api && npm run build:linux

echo -n -e "Install complete, reboot now? (y/n): "
read yn

case $yn in
    [Yy]* )
        # Reboot the system cause who knows
        reboot now
    ;;
    * )
        echo "Not rebooting, install complete. Restart before continuing."
    ;;
esac

# TODO: Cleanup
# sudo rm /etc/apt/sources.list.d/archive_uri-http_apt_llvm_org_*.list && sudo rm /etc/apt/trusted.gpg.d/apt.llvm.org.asc # Cleanup
# test -f /usr/share/doc/kitware-archive-keyring/copyright || sudo rm /usr/share/keyrings/kitware-archive-keyring.gpg
