#!/bin/sh

set -ex

for FILE in *.Dockerfile; do
	NAME="$(echo "$FILE" | cut -f 1 -d '.')"
	podman build -t cyrinux/"$NAME" -f "$FILE" .
done
