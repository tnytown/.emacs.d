(require 'use-package)

(use-package diminish :ensure t)

(use-package which-key :ensure t
  :config
  (which-key-mode 1))

(use-package counsel :ensure t
  :diminish counsel
  :config
  (setq ivy-use-virtual-buffers nil
	ivy-count-format "(%d) ")
  (ivy-mode t)
  
  (setq counsel-find-file-ignore-regexp (concat
         ;; File names beginning with # or .
         "\\(?:\\`[#.]\\)"
         ;; File names ending with # or ~
         "\\|\\(?:\\`.+?[#~]\\'\\)"))
  :bind (
	 ("C-x C-f" . counsel-find-file)
	 ("C-x b" . counsel-switch-buffer)
	 ("M-x" . counsel-M-x)
	 ("C-s" . swiper-isearch)))

(use-package all-the-icons-ivy :ensure t
  :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))

(use-package rg :ensure t
  :config
  (rg-enable-default-bindings))

(use-package avy
  :bind (
	 ("C-:" . avy-goto-char)
	 ("C-'" . avy-goto-char-2)
	 ("M-g f" . avy-goto-line)
	 ("C-c C-j" . avy-resume)))

(use-package ace-window
  :bind (("M-o" . ace-window)
	 ("C-x o" . ace-window)))

;;(use-package ivy
;;  :config
;;  (ivy-mode 1)
;;  (setq ivy-use-virtual-buffers t
;;	ivy-count-format "%d/%d "))

(use-package elcord :ensure t
  :diminish elcord-mode
  :init (setq elcord-use-major-mode-as-main-icon 't) ;; bad defaults
  :config
  (elcord-mode t))

(require 'seq)
(defun aptny/elcord-details (fn)
  "Custom elcord--details-and-state (`FN') advice w/ projectile data."
  (let* ((deets (funcall fn))
		 (ts (car (seq-filter
				(lambda (x) (string= (car x) "timestamps")) deets)))
		 (activity (list
					(cons "details" (projectile-project-name))
					(cons "state" (format "Editing %s" (buffer-name))))))
    
	(when ts (push ts activity))
	activity
  ))
(advice-add 'elcord--details-and-state :around #'aptny/elcord-details)

(fset 'dekauffmanize
   [?\C-s ?| return ?\C-b ?\C-  ?\C-s ?` return ?\C-p ?\C-x ?r ?k])

(fset 'kauffmanize
   [?\C-s ?, return ?\C-n ?\C-b ?\C-  ?\C-s ?` return ?\C-p ?\C-x ?r ?t ?| ?  return])


(global-unset-key (kbd "<left>"))
(global-unset-key (kbd "<right>"))
(global-unset-key (kbd "<up>"))
(global-unset-key (kbd "<down>"))

;; https://www.emacswiki.org/emacs/BackspaceWhitespaceToTabStop
(defun aptny/backspace-whitespace-to-tab-stop ()
  "Delete whitespace backwards to the next tab-stop, otherwise delete one character."
  (interactive)
  (if (or indent-tabs-mode
          (region-active-p)
          (save-excursion
            (> (point) (progn (back-to-indentation)
                              (point)))))
      (call-interactively 'backward-delete-char-untabify)
    (let ((movement (% (current-column) c-basic-offset))
          (p (point)))
      (when (= movement 0) (setq movement c-basic-offset))
      ;; Account for edge case near beginning of buffer
      (setq movement (min (- p 1) movement))
      (save-match-data
        (if (string-match "[^\t ]*\\([\t ]+\\)$" (buffer-substring-no-properties (- p movement) p))
            (backward-delete-char (- (match-end 1) (match-beginning 1)))
          (call-interactively 'backward-delete-char))))))

(global-set-key [?\d] 'aptny/backspace-whitespace-to-tab-stop)
(setq-default electric-indent-inhibit t)
