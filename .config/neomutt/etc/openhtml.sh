#!/bin/sh

# Helps open a file with xdg-open from mutt in a external program without weird side effects.

base=$(basename "$1")
ext="${base##*.}"

file=$(mktemp -p /tmp/ -u --suffix=".$ext")

rm -f "$file"

cp "$1" "$file.html"

setsid browser "$file.html" >/dev/null 2>&1 &
