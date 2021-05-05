# Algorithms for Machine Learning Book

<!-- [![pipeline status](https://gitlab.com/johnnychen94/tufte_algorithms_book/badges/master/pipeline.svg)](https://gitlab.com/johnnychen94/tufte_algorithms_book/commits/master) -->

This book is generated entirely in LaTeX from lecture notes for the course _Machine Learning_ at Stanford University, [CS229](https://cs229.stanford.edu), originally written by Andrew Ng and Chris Ré.
The contributors to the content of this work are Percy Liang and Dorsa Sadign---this collection is a typesetting of existing lecture notes with additions of working Julia implementations. 
Forked from the template [tufte_algorithms_book](https://github.com/sisl/tufte_algorithms_book) used for Algorithms for Optimization.
The template allows for the direct compilation of a print-ready PDF, including support for figures, examples, and exercises.

We do all of our development in Ubuntu (but also support Windows).


Install [Julia](https://julialang.org/downloads/).

Install LaTeX via texlive. We recommend [this repo](https://github.com/scottkosty/install-tl-ubuntu).

Clone the repository to a location of your choosing:
```
git clone https://github.com/mossr/ml_algorithms_book.git
```

Initialize and update the submodules:
```
git submodule init
git submodule update
```

Compile the style:
```
cd style
sudo python setup.py install
cd ..
```

Compile the lexer:
```
cd lexer
sudo python setup.py install
cd ..
```

Install the required Julia packages.
```
make install
```

Install `pdf2svg`, which is used by PGFPlots (we assume Ubuntu - other operating systems may install pdf2svg differently):
```
sudo apt-get install pdf2svg
```

Install [pgfplots](https://ctan.org/pkg/pgfplots).

Install [gnuplots](http://gnuplot.info/download.html).

We require pythontex 0.17, which was just recently tagged. You will probably have to update your version on texlive on miktex. Alternatively, you can download the latest version of pythontex from https://github.com/gpoore/pythontex.

(Note that on arch-based systems, one should use tllocalmgr instead.)

## Test

Running `make test` pulls all the code and then runs all tests in `juliatest` blocks. See `runtests.jl` for details.

## Compilation

* `make compile` compiles the whole book (`make book` works too)
* `make sandbox` will compile `tex/sandbox.tex` (meant for development, e.g., single files)
* `make quick` will only run `lualatex` (skipping `pythontex` and `biber` for quick LaTeX compilation)
	* `make quick-sandbox` does quick compilation for `tex/sandbox.tex`
* `make clean` removes all generated files except `book.pdf` and `sandbox.pdf`
* `make full` runs `clean` and `compile`
	* `make full-sandbox` does full clean/compilation for `tex/sandbox.tex`
* `make save` copies the `book.pdf` file to `p4cs.pdf`


If you host your project under Gitlab, `.gitlab-ci.yml` is a CI/CD template to start with.

## Directory structure

    .
    ├── ...
    ├── jl                      # Julia framework script files
    ├── lectures                # CS221 lecture notes
    ├── tex                     # LaTeX files (main and preamble files)
    │   └── chapter             # LaTeX files (specifically for chapters)
    │       └── figures         # TiKz figures (non-Julia generated)
    └── output                  # Generated output file (.aux files, etc)


## Debugging

To force the submodules to re-initialize:
```
git submodule add --name pygments-style-algforopt https://github.com/sisl/pygments-style-algforopt.git style
git submodule add --name pygments-julia https://github.com/sisl/pygments-julia.git lexer
git submodule add https://github.com/sisl/juliaplots.sty.git
```

If you get this error: `Requirement.parse('prompt-toolkit<2.1.0,>=2.0.0'))`, then run:
```bash
pip install prompt-toolkit==2.0.4
```