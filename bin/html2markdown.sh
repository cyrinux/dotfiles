#!/bin/sh

pandoc --from html \
--to markdown_strict \
--reference-links \
--reference-location=block \
$2
