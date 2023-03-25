#!/bin/bash

if pgrep -f obsidian; then
    flatpak run md.obsidian.Obsidian "obsidian://advanced-uri?vault=Obsidian&commandname=Use%20dark%20mode"
fi
