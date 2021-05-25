#!/bin/bash
apt update
apt install software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt install -y ansible

git clone https://github.com/NelsonLopez69/DevOps2021-1.git
cd DevOps2021-1/Terraform/Ansible/
ansible-playbook -i ./inventory/hosts -l ui  site.yml -vvvvv  -e back_host=${back_host} 