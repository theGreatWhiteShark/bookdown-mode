;;; bookdown-mode.el - Major mode for bookdown and RMarkdown files.

;; Author: Philipp Müller <thetruephil@googlemail.com>
;; Maintainer: Philipp Müller <thetruephil@googlemail.com>
;; Version: 0.1.0
;; Created: October 19, 2017
;; X-URL: https://github.com/theGreatWhiteShark/bookdown-mode
;; URL: https://github.com/theGreatWhiteShark/bookdown-mode
;; Keywords: bookdown, RMarkdown, ESS, polymode, gitbook
;; Package-Requires: ((emacs "24") (cl-lib "0.5"))

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This major mode is derived from Jason R. Blevins' `markdown-mode'.
;; lightning-keymap-mode
;; 
;; It adds syntax highlighting for various features introduced by the
;; R package `bookdown' (e.g. LaTeX equation and specific syntax for
;; citation and references). 
;;
;; Since bookdown and RMarkdown files incorporate sections of both R
;; and Markdown code, it's strongly recommended to use this mode in
;; cooperation with `polymode'. 
;;
;; [markdown-mode]: https://github.com/jrblevin/markdown-mode
;; [bookdown]: https://github.com/rstudio/bookdown
;; [polymode]: https://github.com/vspinu/polymode
;; 
;;
;; For more information check out the projects Github page:
;; https://github.com/theGreatWhiteShark/bookdown-mode

;;; Code
(define-derived-mode bookdown-mode markdown-mode "bookdown"
  "Major mode for editing bookdown and RMarkdown files."
  )

(provide 'bookdown-mode)
;;; End of bookdown-mode.el
