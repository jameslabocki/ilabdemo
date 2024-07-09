#!/bin/bash

flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install --user flathub io.podman_desktop.PodmanDesktop

# https://github.com/flatpak/flatpak/issues/5488
