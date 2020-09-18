;; TODO: remove
(setq gc-cons-threshold 100000000)

;; hack to fix load-history-file-element
;; https://emacs.stackexchange.com/questions/5552/emacs-on-android-org-mode-error-wrong-type-argument-stringp-require-t
(defun load-history-filename-element (file-regexp)
  "Get the first elt of `load-history' whose car matches FILE-REGEXP.
        Return nil if there isn't one."
  (let* ((loads load-history)
         (load-elt (and loads (car loads))))
    (save-match-data
      (while (and loads
                  (or (null (car load-elt))
                      (not (and (stringp (car load-elt)) ; new condition
                                (string-match file-regexp (car load-elt))))))
        (setq loads (cdr loads)
              load-elt (and loads (car loads)))))
    load-elt))

;; transparent titlebar?
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

(defun aptny/load-directory (dir)
  "Load all elisp files in `DIR'."
  (mapc (lambda (x)
		  (let* ((attrs (cdr x))
				 (path (car x))
				 (isdir (eq (file-attribute-type attrs) 't))) ;; symlinks are truthy too
			(load path))) (directory-files-and-attributes dir 't ".*\\.el$")))

;; (M)ELPA configuration
(require 'package)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3") ;; shut up ELPA
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; start server
(server-start)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Bootstrap configuration
(aptny/load-directory "~/.emacs.d/config")
(put 'dired-find-alternate-file 'disabled nil)
