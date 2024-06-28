#!/bin/bash

curl -L -o files/vscode.rpm 'https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64'

sudo rpm -ivh files/vscode.rpm


sudo dnf install gcc glibc-devel zlib-devel 
sdk install maven
sdk install quarkus
