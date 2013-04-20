all:


build:


dev:
	@$(MAKE) -s -j2 devdev


devdev: server csswatch


server:
	python -m SimpleHTTPServer

csswatch:
	sass --compass --watch sass:css


.PHONY: all build dev devdev server
