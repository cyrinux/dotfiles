.PHONY: all
all: build install publish clean push ## Build install and publish everywhere

.PHONY: build
build: ## Build the package
	PKGEXT='.pkg.tar.zst' makepkg -sf

.PHONY: install
install: ## Install the package
	SNAP_PAC_SKIP=true sudo -E pacman --noconfirm -U *.pkg.tar.zst
	backup-packages
	if [ -s unknown.list ]; then \
		xargs -a unknown.list sudo -E pacman -D --asdeps; \
	fi
	backup-packages

.PHONY: publish
publish: ## Publish in local the repo
	gpg --detach-sign --yes *.pkg.tar.zst
	repo-add -s /var/cache/pacman/cyrinux-aur/cyrinux-aur.db.tar *.pkg.tar.zst
	cp *.pkg.tar* /var/cache/pacman/cyrinux-aur/

.PHONY: clean
clean:
	rm -rf pkg src *.pkg.tar* *.log

.PHONY: push
push: ## Push online the repo
	rsyncrepo

.PHONY: help
help: ## This help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

