;; macOS specific configuration
(require 'subr-x)

(when (eq system-type 'darwin) ;; mac specific settings
  (defun kb-meta-detect ()
    (if (string=
	 (shell-command-to-string "/usr/sbin/ioreg -l -p IOUSB | grep 'Razer BlackWidow'")
	 "")
	(progn
	  (message "Internal keyboard detected")
	  (setq mac-option-modifier 'alt)
	  (setq mac-command-modifier 'meta))
      (message "BlackWidow found, flipping keybinds")
      (setq mac-option-modifier 'alt)
      (setq mac-command-modifier 'meta))))

(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)
