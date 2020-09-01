#!/bin/bash
# Script made to install kubectl krew plugin on linux distros

echo "[TASK 1] Verify that git is installed"
yum install -y github

echo "[TASK 2] Downloading krew from Github"
curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz"

echo "[TASK 3] extracting krew for linux"
tar xvf krew.tar.gz ./krew-linux_amd64

echo "[TASK 4] Making krew binary executable"
chmod +x krew-linux_amd64

echo "[TASK 5] Setting up krew"
./krew-linux_amd64 install krew

echo "[TASK 6] appending krew path to /home/$(logname)/.bashrc"
echo "export PATH='${KREW_ROOT:-/home/$(logname)/.krew}/bin:$PATH'" >> /home/$(logname)/.bashrc