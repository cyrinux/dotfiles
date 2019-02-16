#!/bin/sh

# Initial X configuration

xrandr --dpi 96                                                  # Set High DPI
autorandr --change
xcalib -d :0 -s 0 "$HOME/.dotfiles/icm/dell_lattitude_7480.icm"  # Calibrate screen
xset s on -dpms                                                 # Prevent screen from turning on
xset r rate 250 45                                               # Set keyboard repeat rate
