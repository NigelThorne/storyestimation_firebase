all: dist/app.js dist/index.html dist/rooms.html dist/main.css dist/interop.js .tested

dist/main.css: $(shell find styles -type f -name '*.less')
	lessc styles/main.less $@

dist/app.js: $(shell find src -type f -name '*.elm' -o -name '*.js') dist
	elm-make src/App.elm --yes --warn --output=$@

dist:
	@mkdir $@

dist/%.html: static/%.html dist
	cp $< $@

dist/%.js: static/%.js dist
	cp $< $@

dist/%.gif: static/%.gif dist
	cp $< $@

dist/%.png: static/%.png dist
	cp $< $@

dist/%.ico: static/%.ico dist
	cp $< $@

.tested: $(shell find src test -type f -name '*.elm' -o -name '*.js')
	@ elm-test 

TEMPFILE := $(shell mktemp "$$TMPDIR/$$(uuidgen).js")


serve: all 
	@ firebase serve -p 5000 -o 127.0.0.1