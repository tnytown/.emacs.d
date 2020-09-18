(require 'use-package)

(use-package projectile :ensure t
  :init
  (projectile-mode 1)
  (setq projectile-completion-system 'ivy)
  :bind ("C-c p" . 'projectile-command-map))

(use-package magit :ensure t
  :bind (("C-x g" . 'magit-status)
	 ("C-x M-g" . 'magit-dispatch)))
