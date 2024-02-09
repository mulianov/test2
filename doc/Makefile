# SPDX-License-Identifier: BSD-3-Clause

ROOT = README
SRC = $(ROOT).adoc
SRC_STRIPPED = $(ROOT)-stripped.adoc

.PHONY: all
all: pdf html

.PHONY: pdf
pdf: $(ROOT).pdf

$(ROOT).pdf:
	asciidoctor-pdf -d article $(SRC)

.PHONY: html
html: $(ROOT).html

$(ROOT).html:
	asciidoctor -d article -b html $(SRC)

custom.dict: custom.wordlist
	aspell --lang=en create master ./$@ < $<

.PHONY: spell
spell: custom.dict $(SRC)
	sed < $(SRC) > $(SRC_STRIPPED) -e 's/`[^`]\+`//gp' -e '/^----$$/,/^----$$/d'
	aspell --master=en_US --mode=none --add-extra-dicts=./custom.dict \
	    -c $(SRC_STRIPPED)
	$(RM) $(SRC_STRIPPED)

clean:
	rm -f $(ROOT)-stripped.adoc $(ROOT).pdf $(ROOT).html custom.dict
