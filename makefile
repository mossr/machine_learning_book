.PHONY : set-book set-sandbox

CHAPTER :=

install:
	julia --color=yes jl/install.jl

test:
	julia --color=yes jl/pull_julia_code.jl
	julia --color=yes jl/runtests.jl


## Set the tex filename for `book` or `sandbox`
set-book:
	$(eval BOOK := tex/book)
set-sandbox:
	$(eval BOOK := tex/sandbox)


## Full complication
compile-core:
ifdef CHAPTER
	cp $(BOOK).tex $(BOOK).tex.bak
	vim \
	 -c ':/\\begin{document}/,/\\end{document}/s/\(^.*\\\(input\|include\).*$$\)/%\1/' \
	 $(foreach var,$(CHAPTER),-c ':g/\(chapter\|appendix\)\/$(var)/s/^.//' ) \
	 -c :wq \
	 $(BOOK).tex
endif
	-julia --color=yes jl/pull_julia_code.jl && \
	lualatex -shell-escape --aux-directory=output --include-directory=tex --include-directory=output $(BOOK) && \
	pythontex output/$$(basename $(BOOK)) && \
	biber --input-directory=tex output/$$(basename $(BOOK)) && \
	lualatex -shell-escape --aux-directory=output --include-directory=tex --include-directory=output $(BOOK)
ifdef CHAPTER
	mv $(BOOK).tex.bak $(BOOK).tex
endif

compile: set-book compile-core
book: compile # duplicate of `compile`

sandbox: set-sandbox compile-core


## Full clean and compile
full: clean compile
full-sandbox: clean sandbox


## Quickly compile using only lualatex
quick-core:
	lualatex -shell-escape --aux-directory=output --include-directory=tex --include-directory=output $(BOOK)

quick: set-book quick-core

quick-sandbox: set-sandbox quick-core


## Clean generated files
clean:
	rm -rf output

save:
	cp book.pdf alg4ml.pdf