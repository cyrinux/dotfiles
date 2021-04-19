#!/bin/bash

echo "Firejail hardening"
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
