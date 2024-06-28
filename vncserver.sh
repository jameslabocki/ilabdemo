#!/bin/bash

sudo dnf install tigervnc tigervnc-server -y

sudo dnf group install GNOME base-x -y

sudo dnf groupinstall "Server with GUI" -y

sudo systemctl set-default graphical.target

sudo systemctl isolate graphical.target

mkdir ~/.vnc

echo redhat2024 | vncpasswd -f > ~/.vnc/passwd

chown -R `whoami`:`id -g` ~/.vnc/passwd 

chmod 0600 ~/.vnc/passwd

echo 'session=gnome' > ~/.vnc/config

sudo su - 

sudo echo ':1=instruct' >> /etc/tigervnc/vncserver.users

sudo cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service

sudo systemctl enable vncserver@:1.service
sudo systemctl start vncserver@:1.service
