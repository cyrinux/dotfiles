#!/bin/sh

if pgrep -f obsidian; then
    flatpak run md.obsidian.Obsidian 'obsidian://advanced-uri?vault=Obsidian&commandname=Use%20light%20mode'
fi
