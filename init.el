(require 'cl-lib)

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

;; recursively load configs
(defun load-directory (directory)
  (dolist (element (directory-files-and-attributes directory nil nil nil))
    (let* ((path (car element))
           (fullpath (concat directory "/" path))
           (isdir (car (cdr element)))
           (ignore-dir (or (string= path ".") (string= path ".."))))
      (cond
       ((and (eq isdir t) (not ignore-dir))
        (load-directory fullpath))
       ((and (eq isdir nil) (string= (substring path -3) ".el"))
        (load (file-name-sans-extension fullpath)))))))

;; add locallisppath manually
;; (let ((default-directory "/usr/local/share/emacs/site-lisp"))
;;  (normal-top-level-add-subdirs-to-load-path))

;; (setq load-path (cl-union load-path (list "/usr/local/share/emacs/site-lisp")))

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
(load-directory "~/.emacs.d/config")
(put 'dired-find-alternate-file 'disabled nil)
