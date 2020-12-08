%.png: %.dot
	dot -Tpng -o $@ $<

DOTFILES := $(wildcard *.dot)
PNGFILES := $(DOTFILES:.dot=.png)

all: ${PNGFILES}

clean:
	rm -fv *.png
