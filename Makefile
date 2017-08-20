.DEFAULT_GOAL := help
.PHONY: help bashrc git profile vimrc

help:
	@echo "Sets up global config files"
	@echo ""
	@echo "Targets:"
	@echo "bashrc      setup ~/.bashrc"
	@echo "git         setup global git config files (expects blackbox)"
	@echo "profile     setup ~/.profile"
	@echo "vimrc       setup ~/.vimrc (requires: pathogen, syntastic)"

bashrc:
	./setup_user_config.sh bashrc

git:
	./setup_user_config.sh git

profile:
	./setup_user_config.sh profile

vimrc:
	./setup_user_config.sh vimrc
