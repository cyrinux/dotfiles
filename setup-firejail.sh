#!/bin/bash

echo "Install xdg-open firejail wrapper"
sudo gcc -o /usr/local/bin/xdg-open ./src/xdg-open.c
sudo chown root:root /usr/local/bin/xdg-open
sudo chmod 755 /usr/local/bin/xdg-open

echo "Firejail some app"
sudo systemctl enable --now apparmor.service
sudo apparmor_parser -r /etc/apparmor.d/firejail-default
sudo ln -sfv /usr/bin/firejail /usr/local/bin/transmission-gtk
sudo ln -sfv /usr/bin/firejail /usr/local/bin/torbrowser-launcher
sudo ln -sfv /usr/bin/firejail /usr/local/bin/chromium
sudo ln -sfv /usr/bin/firejail /usr/local/bin/firefox
sudo ln -sfv /usr/bin/firejail /usr/local/bin/signal-desktop
sudo ln -sfv /usr/bin/firejail /usr/local/bin/slack
sudo ln -sfv /usr/bin/firejail /usr/local/bin/zathura
sudo ln -sfv /usr/bin/firejail /usr/local/bin/discord
sudo ln -sfv /usr/bin/firejail /usr/local/bin/libreoffice
