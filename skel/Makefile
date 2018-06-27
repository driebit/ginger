SHELL := /bin/bash

.PHONY: elm assets watch minify

default: all

NPM_PATH := ./node_modules/.bin
ASSETS_DIR := ./lib/assets
ELM_DIR := ./lib/elm
SCSS_DIR := ./lib/scss

export PATH := $(NPM_PATH):$(PATH)

all: elm scss assets

assets:
	@mkdir -p lib/dist/assets/ && cp -R ${ASSETS_DIR} lib/dist/

build:
	make deps
	$(MAKE) test -C ${ELM_DIR}
	make all
	make minify

clean:
	@rm -Rf dist/*

deps:
	@npm install
	$(MAKE) deps -C ${ELM_DIR}
	$(MAKE) deps -C ${SCSS_DIR}

distclean: clean
	@rm -Rf node_modules
	$(MAKE) distclean -C ${ELM_DIR}
	$(MAKE) distclean -C ${SCSS_DIR}

elm:
	$(MAKE) -C ${ELM_DIR}
	@cp ${ELM_DIR}/dist/main.js lib/dist/

help:
	@echo "Run: make <target> where <target> is one of the following:"
	@echo "  all                    Compile all Elm and Scss files"
	@echo "  build                  Install deps and compile for production"
	@echo "  clean                  Remove 'dist' folder"
	@echo "  deps                   Install build dependencies"
	@echo "  distclean              Remove build files and dependencies"
	@echo "  help                   Show list of make commands"
	@echo "  init                   Initialize site, clone Elm and Scss skeletons and install deps"
	@echo "  minify                 Minify JS and Css files"
	@echo "  watch                  Compile all Elm and Scss files on file change and reload browser"
	@echo "  watch-elm              Compile all Elm files on file change and reload browser"
	@echo "  watch-scss             Compile all Scss files on file change and reload browser"

init:
	git clone https://github.com/driebit/elm-skeleton ${ELM_DIR}
	git clone https://github.com/driebit/scss-skeleton ${SCSS_DIR}
	make deps
	make all

livereload:
	@livereload . -e 'js, css'

minify:
	@uglifyjs lib/dist/main.js -c --output='lib/dist/main.js'
	@cleancss -o lib/dist/style.css lib/dist/style.css

scss:
	$(MAKE) -C ${SCSS_DIR}
	@cp ${SCSS_DIR}/dist/style.css lib/dist/

watch-elm:
	make livereload & find ${ELM_DIR}/src -name '*.elm' | entr make elm

watch-scss:
	make livereload & find ${SCSS_DIR}/src -name '*.scss' | entr make scss

watch:
	make livereload & \
	find ${SCSS_DIR}/src -name '*.scss' | entr make scss & \
	find ${ELM_DIR}/src -name '*.elm' | entr make elm
