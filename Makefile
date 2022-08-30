

SRC := $(wildcard src/*.fnl)
OBJS := $(subst src/,build/,$(SRC:.fnl=.lua))

# OUT path is in ./build/

.PHONY: default
default: pack

# Build all the sources .fnl in the src directory
# and put the resulting lua files in the build directory
build/%.lua: src/%.fnl
	fennel --compile $< > $@

build: $(OBJS)

run: build
	open -n -a love ./build/

vimrun: run

pack: build
	cd build && zip -r ../build.zip .
	mv build.zip balls.love

clean:
	rm -rf build/*
	rm -rf balls.love

