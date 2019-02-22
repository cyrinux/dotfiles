#!/bin/sh

# Initial X configuration

xrandr --dpi 96                                            # Set High DPI
xcalib "$HOME/.dotfiles/icm/dell_lattitude_7480.icm"       # Calibrate screen
xset s off -dpms                                           # Prevent screen from turning off
xset r rate 250 45                                         # Set keyboard repeat rate
