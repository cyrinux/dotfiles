all: build update clean
force: buildforce update clean
reset: reporeset reposign
build:
	aur build -s --pkgver
buildforce:
	aur build -sf --pkgver
add:
	repoctl update
update:
	sudo pacman -Syyu
clean:
	rm -vf cyrinux-*
backup:
	backup-packages
reporeset:
	repoctl reset
reposign:
	repo-add -s /var/cache/pacman/cyrinux-aur/cyrinux-aur.db.tar
status:
	repoctl status -a
