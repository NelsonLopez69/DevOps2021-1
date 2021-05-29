#!/bin/bash
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansibleterr   
sudo apt install -y ansible

sudo git clone https://github.com/NelsonLopez69/DevOps2021-1.git
cd DevOps2021-1/Terraform/Ansible/
sudo ansible-playbook -i ./inventory/hosts -l back  site.yml -vvvvv  -e database_url=${database_url}