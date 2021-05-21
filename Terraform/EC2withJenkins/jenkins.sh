#!/bin/bash

apt update
apt install software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt install -y ansible

git clone https://github.com/NelsonLopez69/DevOps2021-1.git
git checkout chasqui

cd Terraform/Ansible

ansible-playbook -i ./inventory/hosts -l jk site.yml -vvv