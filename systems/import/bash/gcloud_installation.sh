#!/bin/bash

export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"

sudo apt update

echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository --yes --update ppa:ansible/ansible

sudo apt update && sudo apt install software-properties-common google-cloud-sdk ansible -y
