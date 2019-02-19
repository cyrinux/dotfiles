# Generate PDFs from the Markdown source files
#
# In order to use this makefile, you need some tools:
# - GNU make
# - Pandoc
# - LuaLaTeX
# - DejaVu Sans fonts

# Directory containing source (Markdown) files
source := ./

# Directory containing pdf files
output := docs

# All markdown files in src/ are considered sources
sources := $(wildcard $(source)/*.md)

all: doc install

doc: lualatex wkhtmltopdf

# Convert the list of source files (Markdown files in directory src/)
# into a list of output files (PDFs in directory print/).
objects := $(patsubst %.md,%-lualatex.pdf,$(subst $(source),$(output),$(sources)))

lualatex: $(objects)

# Recipe for converting a Markdown file into PDF using Pandoc
$(output)/%-lualatex.pdf: $(source)/%.md
	pandoc \
		--variable mainfont="DejaVu Sans" \
		--variable monofont="DejaVu Sans Mono" \
		--variable fontsize=11pt \
		--variable geometry:"top=1.5cm, bottom=2.5cm, left=1.5cm, right=1.5cm" \
		--variable geometry:a4paper \
		--metadata pagetitle="$<" \
		--metadata title="$<" \
		--table-of-contents \
		--number-sections \
		-f markdown  $< \
		--pdf-engine=lualatex \
		-o $@

objects := $(patsubst %.md,%-wkhtmltopdf.pdf,$(subst $(source),$(output),$(sources)))

wkhtmltopdf: $(objects)

$(output)/%-wkhtmltopdf.pdf: $(source)/%.md
	pandoc \
		--variable mainfont="DejaVu Sans" \
		--variable monofont="DejaVu Sans Mono" \
		--variable fontsize=11pt \
		--variable geometry:a4paper \
		--variable css="$(output)/src/pandoc.css" \
		--metadata pagetitle="$<" \
		--metadata title="$<" \
		-f markdown  $< \
		--pdf-engine=wkhtmltopdf \
		-o $@

install: setup
		./setup

.PHONY : clean

clean:
	rm -f $(output)/*.pdf
