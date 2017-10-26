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
  :group 'bookdown

  ;; Syntax
  (add-hook 'jit-lock-after-change-extend-region-functions
            #'markdown-font-lock-extend-region-function t t)
  ;; This function is removing the text properties of parts of the
  ;; code we wish to highlight.
  (setq-local syntax-propertize-function #'markdown-syntax-propertize)
  )

;; Highlighting LaTeX-style math equation and inline formulas.
(defcustom bookmark-enable-math t
  "In addition to inline LaTeX equations `bookdown-mode' also
highlights whole LaTeX style equations.

Such objects have to start with a \begin{equation} and end with an
\end{equation}. 

The highlight-colors are set to resemble the once used in AucTeX."
  :group 'bookdown
  :type 'boolean)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;; Syntax table ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq bookdown-regex-equation nil)

(defun bookdown-syntax-propertize-equations (start end)
  "Match LaTeX-style equation from the START to END."
  (save-excursion
    (goto-char start)
    (while (re-search-forward bookdown-regex-equation end t)
      (unless (markdown-code-block-at-pos (match-beginning 0))
	(put-text-property
	 (match-beginning 0) (match-end 0) 'markdown-heading
	 (match-data t))))))

;; List of all customized text properties
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Text-Properties.html#Text-Properties
;; I'm sticking to the code structure of the markdown-mode in this
;; package.
(defvar bookdown--syntax-properties
  (list 'bookdown-equation nil)
  "Property list of all additional bookdown syntactic properties.")

  

(defun bookdown-syntax-propertize (start end)
  "Function used as `syntax-propertize-function'.
START and END delimit region to propertize.

In comparison to its equivalent in markdown-mode it contains a function
for LaTeX-style equations."
  (with-silent-modifications
    (save-excursion
      (remove-text-properties start end markdown--syntax-properties)
      (markdown-syntax-propertize-fenced-block-constructs start end)
      (markdown-syntax-propertize-yaml-metadata start end)
      (markdown-syntax-propertize-pre-blocks start end)
      (markdown-syntax-propertize-blockquotes start end)
      (markdown-syntax-propertize-headings start end)
      (markdown-syntax-propertize-hrs start end)
      (markdown-syntax-propertize-comments start end)
      (bookdown-syntax-propertize-equations start end))))

;; Checks whether the point resides on a character holding
;; the bookdown-equation text property
(defun bookdown-on-equation-p ()
  "Return non-nil if point is on a heading line."
  (get-text-property (point-at-bol) 'bookdown-equation))


;; blub


(defun markdown-font-lock-extend-region-function (start end _)
  "Used in `jit-lock-after-change-extend-region-functions'.
Delegates to `markdown-syntax-propertize-extend-region'. START
and END are the previous region to refontify."
  (let ((res (markdown-syntax-propertize-extend-region start end)))
    (when res
      ;; syntax-propertize-function is not called when character at
      ;; (point-max) is deleted, but font-lock-extend-region-functions
      ;; are called.  Force a syntax property update in that case.
      (when (= end (point-max))
        ;; This function is called in a buffer modification hook.
        ;; `markdown-syntax-propertize' doesn't save the match data,
        ;; so we have to do it here.
        (save-match-data
          (markdown-syntax-propertize (car res) (cdr res))))
      (setq jit-lock-start (car res)
            jit-lock-end (cdr res)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;; Highlight LaTeX equations ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun markdown-match-math-generic (regex last)
  "Match REGEX from point to LAST.
REGEX is either `markdown-regex-math-inline-single' for matching
$..$ or `markdown-regex-math-inline-double' for matching $$..$$."
  (when (and markdown-enable-math (markdown-match-inline-generic regex last))
    (let ((begin (match-beginning 1)) (end (match-end 1)))
      (prog1
          (if (or (markdown-range-property-any
                   begin end 'face (list markdown-inline-code-face
                                         markdown-bold-face))
                  (markdown-range-properties-exist
                   begin end
                   (markdown-get-fenced-block-middle-properties)))
              (markdown-match-math-generic regex last)
            t)
        (goto-char (1+ (match-end 0)))))))


(make-obsolete 'markdown-enable-math 'markdown-toggle-math "v2.1")

(defun markdown-toggle-math (&optional arg)
  "Toggle support for inline and display LaTeX math expressions.
With a prefix argument ARG, enable math mode if ARG is positive,
and disable it otherwise.  If called from Lisp, enable the mode
if ARG is omitted or nil."
  (interactive (list (or current-prefix-arg 'toggle)))
  (setq markdown-enable-math
        (if (eq arg 'toggle)
            (not markdown-enable-math)
          (> (prefix-numeric-value arg) 0)))
  (if markdown-enable-math
      (message "markdown-mode math support enabled")
    (message "markdown-mode math support disabled"))
  (markdown-reload-extensions))

(defun markdown-mode-font-lock-keywords-math ()
  "Return math font lock keywords if support is enabled."
  (when markdown-enable-math
    (list
     ;; Display mode equations with brackets: \[ \]
     (cons markdown-regex-math-display '((1 markdown-markup-face prepend)
                                         (2 markdown-math-face append)
                                         (3 markdown-markup-face prepend)))
     ;; Equation reference (eq:foo)
     (cons "\\((eq:\\)\\([[:alnum:]:_]+\\)\\()\\)" '((1 markdown-markup-face)
                                                     (2 markdown-reference-face)
                                                     (3 markdown-markup-face)))
     ;; Equation reference \eqref{foo}
     (cons "\\(\\\\eqref{\\)\\([[:alnum:]:_]+\\)\\(}\\)" '((1 markdown-markup-face)
                                                           (2 markdown-reference-face)
                                                           (3 markdown-markup-face))))))
(provide 'bookdown-mode)
;;; End of bookdown-mode.el
