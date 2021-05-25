#!/bin/bash
apt update
apt install software-properties-common
apt-add-repository --yes --update ppa:ansible/ansibleterr   
apt install -y ansible

git clone https://github.com/NelsonLopez69/DevOps2021-1.git
cd DevOps2021-1/Terraform/Ansible/
ansible-playbook -i ./inventory/hosts -l back  site.yml -vvvvv  -e database_url=${database_url}