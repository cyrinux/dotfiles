.PHONY: all
all: build install refresh publish clean

.PHONY: build
build: ## Build the meta-package
	@echo 📦 Build the meta-package
	mockbuild

.PHONY: install
install: ## Install the meta-package
	@echo 📦 Install the meta-package
	SNAP_PAC_SKIP=true sudo dnf install --newpackage -y *.noarch.rpm

.PHONY: refresh
refresh: ## Refresh the backup lists
	@echo 🧹 Backup packages
	backup-packages
	xargs -r -a unknown.list sudo dnf -q mark remove
	backup-packages

.PHONY: clean
clean: ## Cleanup
	rm -rf *.log *.rpm

.PHONY: publish
publish: ## Push online the local repo
	@echo 📦 Sync repository
	copr build --nowait personal cyrinux-metapackage.spec

.PHONY: help
help: ## This help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

