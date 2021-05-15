#!/bin/bash
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

git clone https://github.com/NelsonLopez69/DevOps2021-1.git
cd DevOps2021-1/Terraform/Ansible/

sudo ansible-playbook -i ./inventory/hosts -l db site.yml -vvv -e user=admin -e password=password