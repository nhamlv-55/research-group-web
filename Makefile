# targets that aren't filenames
.PHONY: all clean deploy build serve

all: build

BIBBLE = bibble

_includes/pubs.html: bib/pubs.bib bib/publications.tmpl
	mkdir -p _includes
	$(BIBBLE) $+ > $@

build: _includes/pubs.html
	jekyll build

# you can configure these at the shell, e.g.:
# SERVE_PORT=5001 make serve
SERVE_HOST ?= 127.0.0.1
SERVE_PORT ?= 5000

serve: _includes/pubs.html
	jekyll serve --port $(SERVE_PORT) --host $(SERVE_HOST)

clean:
	$(RM) -r _site _includes/pubs.html

DEPLOY_HOST ?= yourwebpage.com
DEPLOY_PATH ?= ../aemari.github.io/
RSYNC := rsync --compress --recursive --checksum --itemize-changes --delete -e ssh

deploy: _includes/pubs.html
	jekyll build
	cp -r _site/* $(DEPLOY_PATH)
	cd $(DEPLOY_PATH)
	git add --all
	git commit -m "update website"
	git push
