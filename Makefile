# Directory containing source (Markdown) files
source := ./

# Directory containing pdf files
output := docs

# All markdown files in src/ are considered sources
sources := $(wildcard $(source)/*.md)

all: install doc

doc: wkhtmltopdf

# Convert the list of source files (Markdown files in directory src/)
# into a list of output files (PDFs in directory print/).
objects := $(patsubst %.md,%-lualatex.pdf,$(subst $(source),$(output),$(sources)))

lualatex: $(objects)

# Recipe for converting a Markdown file into PDF using Pandoc
$(output)/%-lualatex.pdf: $(source)/%.md
	@pandoc \
		--variable fontsize=11pt \
		--variable geometry:"top=1.5cm, bottom=2.5cm, left=1.5cm, right=1.5cm" \
		--variable geometry:a4paper \
		--highlight-style zenburn \
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
	@pandoc \
		--variable fontsize=11pt \
		--variable geometry:a4paper \
		--highlight-style zenburn \
		--variable css="$(output)/src/pandoc.css" \
		--metadata pagetitle="$<" \
		--metadata title="$<" \
		-f markdown  $< \
		--pdf-engine=wkhtmltopdf \
		-o $@

.PHONY: setup-system
setup-system:
	@./setup-system.sh
	@./setup-firejail.sh

.PHONY: setup-user
setup-user:
	@./setup-user.sh

.PHONY: setup-firejail
setup-firejail:
	@./setup-firejail.sh

.PHONY: install
install: build-metapackage setup-system setup-user

.PHONY: build-metapackage
build-metapackage:
	@cd packages && \
	make

.PHONY: install-metapackage
install-metapackage:
	sudo pacman -Sy
	sudo pacman -Rs --noconfirm -dd iptables
	yes Y | sudo pacman -Sy --noconfirm cyrinux

.PHONY: build-podman
build-podman:
	podman build -t archlinux/dotfiles:latest -f docker/archlinux/Dockerfile .

.PHONY: ci
# ci: install-metapackage setup-system setup-user
ci: install-metapackage


.PHONY: test
test: build-podman
	podman run --rm \
	    --tmpfs /tmp \
	    --tmpfs /run \
	    -v "/sys/fs/cgroup:/sys/fs/cgroup:ro" \
	    archlinux/dotfiles \
	    make ci

.PHONY: clean
clean:
	rm -f $(output)/*.pdf
