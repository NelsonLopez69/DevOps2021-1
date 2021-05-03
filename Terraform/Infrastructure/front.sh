#!/bin/bash
sudo su
apt update
apt install software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt install -y ansible


##falta aqui la carpeteada
##Ver el video para darse cuenta como manuel hace eso,de poner una variable de ambiente cuando ejecuta este script
##probar el playbook del back desde cero, borrando el contenedor actual
##Para las instancias solas si se les puede agregar una ip, con eso basta, hacer una var y meter ahi la ip de la
##instancia de la db.
##Buscar como obtener la ip del lb

##En las paginas esta resuelto lo de el lb para back y front

##Primero que todo probar el palybook del back bien, luego el front, luego el lb
sudo ansible-playbook -i ./inventory/hosts -l back  site.yml -vvvvv  -e database_url=http://localhost:5984