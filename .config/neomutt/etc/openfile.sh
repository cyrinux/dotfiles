#!/bin/sh

# Helps open a file with xdg-open from mutt in a external program without weird side effects.

base=$(basename "$1")
ext="${base##*.}"

file=$(mktemp -p ~/Downloads/ -u --suffix=".$ext")

rm -f "$file"

cp "$1" "$file"

setsid gio open "$file" >/dev/null 2>&1 &
