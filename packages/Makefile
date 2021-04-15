.PHONY: all
all: build install refresh publish clean sync

.PHONY: build
build: ## Build the meta-package
	PKGEXT='.pkg.tar.zst' makepkg -sf

.PHONY: install
install: ## Install the meta-package
	SNAP_PAC_SKIP=true sudo -E pacman --noconfirm -U *.pkg.tar.zst

.PHONY: refresh
refresh: ## Refresh the backup lists
	backup-packages
	if [ -s unknown.list ]; then \
		xargs -a unknown.list sudo -E pacman -D --asdeps; \
	fi
	backup-packages

.PHONY: publish
publish: ## Publish the meta-package in local the repo
	gpg --detach-sign --yes *.pkg.tar.zst
	repo-add -s /var/cache/pacman/cyrinux-aur-local/cyrinux-aur-local.db.tar *.pkg.tar.zst
	cp *.pkg.tar* /var/cache/pacman/cyrinux-aur-local/

.PHONY: clean
clean: ## Cleanup
	rm -rf pkg src *.pkg.tar* *.log

.PHONY: sync
push: ## Push online the local repo
	sudo systemctl start backup-repo@pkgbuild
	sudo systemctl status backup-repo@pkgbuild

.PHONY: became-official
became-official: ## Clean packages that became official
	@for pkg in $(checkofficial); do rm -f /var/cache/pacman/cyrinux-aur*/${pkg}*; repoctl update; sudo pacman -Sy --no-confirm community/${pkg}; done
	sudo pacman -Sy

.PHONY: show-packages-by-size
show-packages-by-size: ## Show installed packages list sorted by size
	@expac "%n %m" -l'\n' -Q $(pacman -Qq) | sort -rhk 2 | less

.PHONY: help
help: ## This help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

