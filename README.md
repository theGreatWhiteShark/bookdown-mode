**UNDER CONSTRUCTION!**

# Introduction

**bookdown-mode** is intended to become a major mode for editing [bookdown](https://bookdown.org/yihui/bookdown/) and R Markdown documents. 

Bookdown makes use of the feature-rich environment of recent [pandoc](http://pandoc.org/) versions, allowing for not just inline equations, but full-fledged LaTeX-style equation blocks. In addition it incorporates BibTeX-based citations and cross-references. 

To highlight all of these new features in a nice way, I intend to fuse [markdown-mode](https://github.com/jrblevin/markdown-mode) with some [AUCTeX](https://github.com/giordano/auctex) (for the LaTeX equation blocks) and add a couple of custom font-locks for the cross-references etc.

# Installation

Since bookdown files, and R Markdown files in general, combine chunks of both markdown and R code, the use of **bookdown-mode** on its own is not intended. Instead, it's best used in combination with **polymode**. I would recommend to use my own [fork](https://github.com/theGreatWhiteShark/polymode) of the mode, since it already relies **bookdown-mode** instead over markdown-mode.

In order to use it, add the following lines to your *.emacs* configuration file.

``` lisp
;; Adding the repository
(setq load-path (append '("PATH-TO-POLYMODE"
                          "PATH-TO-POLYMODE/modes"
						  "PATH-TO-BOOKDOWN-MODE" ) load-path))
;; Install/Load the packages
(require 'bookdown-mode)
(require 'poly-R)
(require 'poly-bookdown)
;; Tell Emacs to use ESS and bookdown-mode for .Rmd files.
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-bookdown+r-mode))
```

# Progress

Since this is the first major mode I'm authoring, there is MUCH stuff to be done and for now the code on the *Master* branch doesn't do anything markdown-mode isn't already doing. But since this mode is derived from markdown-mode, there is no harm (yet :)) using it. If you are curious about the current state of the project, head over to the [develop](https://github.com/theGreatWhiteShark/bookdown-mode/tree/develop) branch!

For the time being I would recommend to enable the mathematical highlighting provided by the markdown-mode to have at least a low-level fontification of your equations. To do so, add the following line to your *.emacs*

``` lisp
(custom-set-variables '(markdown-enable-math t))
```

This will color your inline equations. If you want to highlight your LaTeX-style equation blocks as well, insert `$$` right before and after a block. 

``` tex
$$\begin{equation}
  M_n =  \max\left\{ X_1, \ldots, X_n \right\}
  (\#eq:rescaling)
\end{equation}$$
```

---

### License

This package is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License, version 3, as
published by the Free Software Foundation.

This program is distributed in the hope that it will be useful, but
without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.  See the GNU
General Public License for more details.

A copy of the GNU General Public License, version 3, is available at
<http://www.r-project.org/Licenses/GPL-3>
