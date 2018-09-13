SHELL := /bin/bash

.PHONY: elm assets watch minify

default: all

NPM_PATH := ./node_modules/.bin
ASSETS_DIR := ./lib/assets
DIST_DIR := ./lib/dist
ELM_DIR := ./lib/elm
SCSS_DIR := ./lib/scss

export PATH := $(NPM_PATH):$(PATH)

all: elm scss assets

assets:
	@mkdir -p ${DIST_DIR}/assets/ && cp -R ${ASSETS_DIR} ${DIST_DIR}

build: deps test all minify

clean:
	@rm -Rf ${DIST_DIR}/*

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
	@cp ${ELM_DIR}/dist/main.js ${DIST_DIR}

help:
	@echo "Run: make <target> where <target> is one of the following:"
	@echo "  all                    Compile all Elm and Scss files"
	@echo "  assets                 Copy assets to dist folder"
	@echo "  build                  Install deps and compile for production"
	@echo "  clean                  Remove 'dist' folder"
	@echo "  deps                   Install build dependencies"
	@echo "  distclean              Remove build files and dependencies"
	@echo "  elm                    Compile Elm files"
	@echo "  help                   Show list of make commands"
	@echo "  init                   Clone Elm and Scss skeletons and install deps"
	@echo "  livereload             Start livereload server, watch js and css file"
	@echo "  minify                 Minify JS and Css files"
	@echo "  scss                   Compile Scss files"
	@echo "  test                   Run the Elm tests"
	@echo "  watch                  Compile all Elm and Scss files on file change and reload browser"
	@echo "  watch-elm              Compile all Elm files on file change and reload browser"
	@echo "  watch-scss             Compile all Scss files on file change and reload browser"

init:
	git clone https://github.com/driebit/elm-skeleton ${ELM_DIR}
	git clone https://github.com/driebit/scss-skeleton ${SCSS_DIR}
	make deps
	make all

livereload:
	@node_modules/livereload/bin/livereload.js . -e 'js, css'

minify:
	@npx uglify-js ${DIST_DIR}/main.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | npx uglify-js --mangle --output=${DIST_DIR}/main.js
	@node_modules/clean-css-cli/bin/cleancss -o ${DIST_DIR}/style.css ${DIST_DIR}/style.css

scss:
	$(MAKE) -C ${SCSS_DIR}
	@cp ${SCSS_DIR}/dist/style.css ${DIST_DIR}

test:
	$(MAKE) test -C ${ELM_DIR}

watch-elm:
	make livereload & find ${ELM_DIR}/src -name '*.elm' | entr make elm

watch-scss:
	make livereload & find ${SCSS_DIR}/src -name '*.scss' | entr make scss

watch:
	make livereload & \
	find ${SCSS_DIR}/src -name '*.scss' | entr make scss & \
	find ${ELM_DIR}/src -name '*.elm' | entr make elm
