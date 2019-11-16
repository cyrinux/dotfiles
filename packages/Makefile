PHONY: all
all: build repoupdate
force: buildforce repoupdate update
asdeps: unknownasdeps
reset: reporeset reposign
build:
	aur build -s --pkgver
buildforce:
	aur build -sf --pkgver
repoupdate:
	repoctl update
update:
	sudo pacman -Syyu
clean: repoupdate
backup:
	backup-packages
reporeset:
	repoctl reset
reposign:
	repo-add -s /var/cache/pacman/cyrinux-aur/cyrinux-aur.db.tar
	repo-add -s /var/cache/pacman/cyrinux-aur/cyrinux-aur.db.tar
status:
	repoctl status -a
unknownasdeps:
	sudo pacman -D --asdeps $(shell cat unknown.list)
