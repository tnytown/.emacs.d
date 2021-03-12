(require 'use-package)
(require 're-builder)
(setq reb-re-syntax 'string)

;; delimiter pairing
(electric-pair-mode 1)

;; fill column
(setq-default fill-column 100)

;; indentation
(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(use-package direnv :ensure t
  :config
  (direnv-mode))

(when nil
  (use-package exec-path-from-shell :ensure t
  :config
  ;; (setenv "SHELL" "/usr/bin/env zsh")
  ;; (setq shell-file-name "/bin/zsh")
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-envs
   '("PATH"))))

(use-package flycheck :ensure t
  :init
  (global-flycheck-mode))

(use-package company :ensure t
  :config
  (setq company-idle-delay 0)
  (global-company-mode t))

(use-package yasnippet :ensure t
  :hook (prog-mode . yas-minor-mode))

;; languages
(use-package lsp-mode :ensure t :commands lsp
  :hook (rust-mode . lsp)
  :hook (python-mode . lsp)
  :hook (c-mode . lsp)
  :hook (c++-mode . lsp)
  :hook (java-mode . lsp)
  :hook (web-mode . lsp)
  :hook (typescript-mode . lsp)
  :init
  (progn
    (setq lsp-diagnostic-package :flycheck
;;		lsp-rust-server 'rust-analyzer
		lsp-rust-analyzer-cargo-load-out-dirs-from-check t
		lsp-rust-analyzer-proc-macro-enable t
		read-process-output-max (* 1024 1024)))
  (when (eq system-type 'darwin)
    (setq lsp-clients-clangd-executable "/usr/bin/xcrun"
          lsp-clients-clangd-args
          '("clangd" "-compile-commands-dir=build"))))

(use-package lsp-ui :ensure t :commands lsp-ui-mode
  :disabled
  :init
  (setq lsp-ui-doc-enable 0))

(use-package rust-mode :ensure t
  :hook (rust-mode . (lambda () (setq indent-tabs-mode nil)))
  :init
  (setq rust-format-on-save t))

(use-package typescript-mode :ensure t)
(use-package web-mode :ensure t
  :mode "\\.tsx\\'")
(use-package flycheck-rust :ensure t
  :hook (rust-mode . flycheck-rust-setup))

(use-package nginx-mode :ensure t)
(use-package php-mode :ensure t)
(use-package yaml-mode :ensure t)

(use-package lsp-java :ensure t :after lsp
  :config
  (setq lsp-java-format-settings-url "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml")
  (setq lsp-java-format-enabled nil))

;; ocaml
(let ((opam-share (ignore-errors (car (process-lines "opam" "config" "var" "share")))))
  (when (and opam-share (file-directory-p opam-share))
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))))

(use-package merlin :pin manual
  :hook (tuareg-mode . merlin-mode)
  :init
  (setq merlin-command 'opam))

(use-package flycheck-ocaml :after merlin :ensure t
  :init
  (setq merlin-error-after-save nil)
  (flycheck-ocaml-setup))

;;(with-eval-after-load 'merlin
;;  (setq merlin-error-after-save nil))

;; Make company aware of merlin
(with-eval-after-load 'company
  (add-to-list 'company-backends 'merlin-company-backend))

(use-package tuareg :after merlin :ensure t)

(when nil
(use-package ocamlformat
  :hook (tuareg-mode . (lambda ()
			      (define-key tuareg-mode-map (kbd "C-M-<tab>") #'ocamlformat)
			      (add-hook 'before-save-hook #'ocamlformat-before-save)))))

;; (add-hook 'prog-mode-hook 'turn-on-auto-fill)

(use-package nix-mode :ensure t
  :mode "\\.nix\\'")

(use-package qml-mode :ensure t)

;; scripting
(use-package fish-mode :ensure t)

;; buildsystems
(use-package cmake-mode :ensure t)
(use-package cmake-project :ensure t)


(defun cmake-project-check-hook ()
  (if (file-exists-p "CMakeLists.txt") (cmake-project-mode)))

(add-hook 'c-mode-hook 'cmake-project-check-hook)
(add-hook 'c++-mode-hook 'cmake-project-check-hook)

(use-package editorconfig :ensure t
  :config
  (editorconfig-mode 1))

(use-package clang-format+ :ensure t
  :hook (c++-mode . clang-format+-mode)
  :hook (c-mode . clang-format+-mode))

;; python
(use-package pyvenv :ensure t)

;; file formats
(use-package csv-mode :ensure t)

(defun aptny/projectile-pyenv-mode-set ()
  "Set pyenv version from .pyenv_version."
  (let* ((default-directory (projectile-project-root))
	(py-version-file (expand-file-name ".pyenv_version"))
	(py-version (if (file-exists-p py-version-file)
			(string-trim (with-temp-buffer
			  (insert-file-contents py-version-file)
			  (buffer-string))))))
    (if (bound-and-true-p py-version)
	(pyenv-mode-set py-version)
      (pyenv-mode-unset))))

(add-hook 'projectile-after-switch-project-hook
	  'aptny/projectile-pyenv-mode-set)

(use-package auctex :ensure t :defer t
  :config
  (setq TeX-PDF-mode t))
(use-package auctex-latexmk :ensure t
  :config
  (auctex-latexmk-setup)
;;  (let ((pv '("latexmk-preview" "latexmk -pvc %s" TeX-run-command t t :help "Run
;;  Latexmk in continuous preview mode")))
;;    (add-to-list 'TeX-command-list pv t))
  ;;  (setq TeX-command-default "latexmk-preview")
  
  )

;;(defun aptny/asm-mode-indent
;;    "Indentation function for asm-mode."
;;)

(setq asm-comment-char ?\#)
(defun aptny/asm-mode-dumb ()
  "Mode hook to fix asm-mode's dumb behavior."
  (electric-indent-local-mode)
  ;;  (define-key asm-mode-map ":" nil) ;; todo non-att syntax ???
  (setq tab-always-indent (default-value 'tab-always-indent)))
(add-hook 'asm-mode-hook #'aptny/asm-mode-dumb)
