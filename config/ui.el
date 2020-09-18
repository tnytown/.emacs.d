(require 'use-package)

;; fixing things in the default UI that irk me
(setq-default cursor-type 'bar)
(setq inhibit-startup-screen t)
(menu-bar-mode t)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
;;(global-display-line-numbers-mode 1)
(setq ring-bell-function 'ignore)
(setq confirm-kill-processes nil)
;;(pixel-scroll-mode 1)
;;(setq mouse-wheel-progressive-speed nil)
;;(setq ns-use-mwheel-momentum nil)
;;(setq-default pixel-dead-time 0.0) TODO: figure out scrolling
(setq inhibit-compacting-font-caches t)

(set-face-attribute 'default nil :height 130)

(setq mac-mouse-wheel-smooth-scroll nil)
(setq scroll-conservatively 101)
;; Optimize mouse wheel scrolling for smooth-scrolling trackpad use.
  ;; Trackpads send a lot more scroll events than regular mouse wheels,
  ;; so the scroll amount and acceleration must be tuned to smooth it out.
  (setq
   ;; If the frame contains multiple windows, scroll the one under the cursor
   ;; instead of the one that currently has keyboard focus.
   mouse-wheel-follow-mouse 't
   ;; Completely disable mouse wheel acceleration to avoid speeding away.
   mouse-wheel-progressive-speed nil
   ;; The most important setting of all! Make each scroll-event move 2 lines at
   ;; a time (instead of 5 at default). Simply hold down shift to move twice as
   ;; fast, or hold down control to move 3x as fast. Perfect for trackpads.
   mouse-wheel-scroll-amount '(2 ((shift) . 4) ((control) . 6)))

(defun my-scroll-hook(_)
  "Increase gc-threshold before scroll and set it back after."
  (setq gc-cons-threshold most-positive-fixnum)
  (run-with-idle-timer 3 nil (lambda () (setq gc-cons-threshold (* 8 1024 1024)))))

;;(advice-add 'scroll-up-line :before 'my-scroll-hook)
;;(advice-add 'scroll-down-line :before 'my-scroll-hook)

(use-package all-the-icons :ensure t)

(defvar ap/company-box-icons-lsp
      `(( 1  . ,(all-the-icons-faicon "file-text-o" :v-adjust -0.0575))     ; Text
        ( 2  . ,(all-the-icons-faicon "cube" :v-adjust -0.0575))            ; Method
        ( 3  . ,(all-the-icons-faicon "cube" :v-adjust -0.0575))            ; Function
        ( 4  . ,(all-the-icons-faicon "cube" :v-adjust -0.0575))            ; Constructor
        ( 5  . ,(all-the-icons-faicon "tag" :v-adjust -0.0575))             ; Field
        ( 6  . ,(all-the-icons-faicon "tag" :v-adjust -0.0575))             ; Variable
        ( 7  . ,(all-the-icons-faicon "cog" :v-adjust -0.0575))             ; Class
        ( 8  . ,(all-the-icons-faicon "cogs" :v-adjust -0.0575))            ; Interface
        ( 9  . ,(all-the-icons-alltheicon "less"))                          ; Module
        (10  . ,(all-the-icons-faicon "wrench" :v-adjust -0.0575))          ; Property
        (11  . ,(all-the-icons-faicon "tag" :v-adjust -0.0575))             ; Unit
        (12  . ,(all-the-icons-faicon "tag" :v-adjust -0.0575))             ; Value
        (13  . ,(all-the-icons-material "content_copy" :v-adjust -0.2))     ; Enum
        (14  . ,(all-the-icons-faicon "tag" :v-adjust -0.0575))             ; Keyword
        (15  . ,(all-the-icons-material "content_paste" :v-adjust -0.2))    ; Snippet
        (16  . ,(all-the-icons-material "palette" :v-adjust -0.2))          ; Color
        (17  . ,(all-the-icons-faicon "file" :v-adjust -0.0575))            ; File
        (18  . ,(all-the-icons-faicon "tag" :v-adjust -0.0575))             ; Reference
        (19  . ,(all-the-icons-faicon "folder" :v-adjust -0.0575))          ; Folder
        (20  . ,(all-the-icons-faicon "tag" :v-adjust -0.0575))             ; EnumMember
        (21  . ,(all-the-icons-faicon "tag" :v-adjust -0.0575))             ; Constant
        (22  . ,(all-the-icons-faicon "cog" :v-adjust -0.0575))             ; Struct
        (23  . ,(all-the-icons-faicon "bolt" :v-adjust -0.0575))            ; Event
        (24  . ,(all-the-icons-faicon "tag" :v-adjust -0.0575))             ; Operator
        (25  . ,(all-the-icons-faicon "cog" :v-adjust -0.0575))             ; TypeParameter
        ))

(use-package company-box :ensure t
  :hook (company-mode . company-box-mode)
  :config
  (setq company-box-icons-alist 'company-box-icons-all-the-icons))

;; theming
(use-package solarized-theme
  :ensure t
  ;;  :config (load-theme 'solarized-dark t))
  )

(use-package tao-theme
  :ensure t
  ;;:config (setq tao-theme-use-sepia nil) (load-theme 'tao-yin t)
  )

(use-package modus-vivendi-theme :ensure t
  :config
  (setq modus-vivendi-theme-faint-syntax t)
  (load-theme 'modus-vivendi t))

(use-package color-identifiers-mode
  :ensure t
  ;;  :hook (after-init . global-color-identifiers-mode)
  )

;;(use-package highlight-indent-guides :ensure t
;; :hook (prog-mode . highlight-indent-guides-mode)
;; :config (setq highlight-indent-guides-method 'character))

;; modeline
(use-package doom-modeline :ensure t
  :requires all-the-icons
  :init
  (setq doom-modeline-lsp t)
  :hook (after-init . doom-modeline-mode))

;; sublimity
;;(use-package sublimity
;;  :ensure t)
;;(use-package sublimity-map)
(use-package minimap :ensure t
  :config (setq minimap-window-location 'right))

;; transparent titlebar
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
