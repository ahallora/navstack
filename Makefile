bin          = ./node_modules/.bin
stylus       = $(bin)/stylus
uglifyjs     = $(bin)/uglifyjs
mdextract    = $(bin)/mdextract
autoprefixer = $(bin)/autoprefixer

all: navstack.css Readme.md
navstack.css: navstack.styl
	${stylus} < $^ | ${autoprefixer} -b "> 1%" > $@

Readme.md: navstack.js
	${mdextract} -u $@

size:
	@echo "  .js        " `cat navstack.js | wc -c` bytes
	@echo "  .min.js    " `cat navstack.js | ${uglifyjs} -m | wc -c` bytes
	@echo "  .min.js.gz " `cat navstack.js | ${uglifyjs} -m | gzip | wc -c` bytes
	@echo
	@echo "  .css       " `cat navstack.css | wc -c` bytes
	@echo "  .min.css   " `cat navstack.css | ${stylus} -c | wc -c` bytes
	@echo "  .min.css.gz" `cat navstack.css | ${stylus} -c | gzip | wc -c` bytes

bump:
	bump navstack.js package.json bower.json

site: all
	@if [ ! -d site ]; then echo "  !  err: clone the site repo into ./site"; exit 1; fi
	cp navstack.js site
	cp navstack.css site
	cp vendor/jquery-2.0.2.js site/vendor/jquery-2.0.2.js

.PHONY: site
