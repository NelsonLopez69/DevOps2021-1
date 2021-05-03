#!/bin/bash
sudo su
apt update
apt install software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt install -y ansible

git clone https://github.com/NelsonLopez69/DevOps2021-1.git

cd Terraform/Ansible/

ansible-playbook -i ./inventory/hosts -l db database.yml -vvv -e user=admin -e password=password