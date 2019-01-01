all: test

test:
	@if ! type shpec > /dev/null 2>&1; then echo "Installing shpec..."; PREFIX=~ sh -c "`curl -L https://raw.github.com/rylnd/shpec/master/install.sh`"; fi
	@bash -c shpec
