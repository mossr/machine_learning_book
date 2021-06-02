# Machine Learning Book

<!-- [![pipeline status](https://gitlab.com/johnnychen94/tufte_algorithms_book/badges/master/pipeline.svg)](https://gitlab.com/johnnychen94/tufte_algorithms_book/commits/master) -->

[![PDF](https://img.shields.io/badge/pdf-machine%20learning-d2c295)](https://github.com/mossr/machine_learning_book/blob/master/ml.pdf)


This book is generated entirely in LaTeX from lecture notes for the course _Machine Learning_ at Stanford University, [CS229](http://cs229.stanford.edu/), originally written by Andrew Ng, Christopher Ré, Moses Charikar, Tengyu Ma, Anand Avati, Kian Katanforoosh, Yoann Le Calonnec, and John Duchi.
This collection is a typesetting of existing lecture notes.
Forked from the template [tufte_algorithms_book](https://github.com/sisl/tufte_algorithms_book) used for Algorithms for Optimization.
The template allows for the direct compilation of a print-ready PDF, including support for figures, examples, and exercises.

We do all of our development in Ubuntu (but also support Windows).


Install [Julia](https://julialang.org/downloads/).

Install LaTeX via texlive. We recommend [this repo](https://github.com/scottkosty/install-tl-ubuntu).

Clone the repository to a location of your choosing:
```
git clone https://github.com/mossr/machine_learning_book.git
```

Initialize and update the submodule ([juliaplots.sty](https://github.com/sisl/juliaplots.sty)):
```
git submodule init
git submodule update
```

Install lexer and style (may need `pip3` instead):
```
pip install --upgrade git+https://github.com/sisl/pygments-julia#egg=pygments_julia
pip install --upgrade git+https://github.com/sisl/pygments-style-algfordm#egg=pygments_style_algforopt
```

Install the required Julia packages.
```
julia jl/install.jl
```

Install `pdf2svg`, which is used by PGFPlots (we assume Ubuntu - other operating systems may install pdf2svg differently):
```
sudo apt-get install pdf2svg
```
For `pdf2svg` on Windows (place `dist-*` directory on PATH): https://github.com/jalios/pdf2svg-windows


Install [pgfplots](https://ctan.org/pkg/pgfplots).

We require pythontex 0.17, which was just recently tagged. You will probably have to update your version on texlive on miktex. Alternatively, you can download the latest version of pythontex from https://github.com/gpoore/pythontex.

(Note that on arch-based systems, one should use tllocalmgr instead.)

## Test

Running the following pulls all the code and then runs all tests in `juliatest` blocks. See `runtests.jl` for details.

```
julia jl/runtests.jl
```

## Compilation

Install `latexmk` from: https://mg.readthedocs.io/latexmk.html#installation

* `latexmk` will compile everything (see `output/` for PDF).
    * `latexmk` will intelligently compile only the necessary bits.
* `latexmk -c` will clean up generated files.
* `latexmk -C` will clean up generated files (including `.pdf`).
* `latexmk tex/sandbox.tex` will compile `tex/sandbox.tex` (Note, the forward slash is important. This is meant for development, e.g., single files)

If you host your project under Gitlab, `.gitlab-ci.yml` is a CI/CD template to start with.


If you host your project under Gitlab, `.gitlab-ci.yml` is a CI/CD template to start with.

## Directory structure

    .
    ├── ...
    ├── jl                      # Julia framework script files
    ├── lectures                # CS229 lecture notes
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