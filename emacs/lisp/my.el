;;; my.el --- Personal helper functions -*- lexical-binding: t; -*-

(defmacro my-key-prefix (prefix)
  `(lambda ()
     (interactive)
     (let ((message-log-max nil)) (message "%s" ,prefix))
     (let* ((event (read-event))
            (description (single-key-description event))
            (sequence (concat ,prefix description))
            (command (key-binding (kbd sequence))))
       (if (and command (not (keymapp command)))
           (call-interactively command)
         (message "%s is undefined" sequence)))))

(defvar my-font-name-mono nil)
(defvar my-font-name-sans nil)
(defvar my-font-size 0)
(defun my-font-change-size (increment)
  (setq my-font-size (+ my-font-size increment))
  (set-face-attribute
   'default nil
   :family my-font-name-mono
   :height my-font-size)
  (set-face-attribute
   'variable-pitch nil
   :family my-font-name-sans
   :height my-font-size)
  (message "Set font size to %d" my-font-size))

(defun my-arrange-windows ()
  (interactive)
  (select-window
   (if (< (window-pixel-height) (window-pixel-width))
       (split-window-horizontally)
     (split-window-vertically))))

(defun my--language-package-name (language)
  (intern
   (if (string-suffix-p "!" language)
       (substring language 0 -1)
     (format "%s-mode" language))))

(defun my--install-language (language)
  `(use-package ,(my--language-package-name (symbol-name language))
     :ensure t
     :defer t))

(defmacro my-install-languages (&rest languages)
  `(progn ,@(mapcar #'my--install-language languages)))

(defun my-locate-dominating-files (file names)
  (cl-some
   (lambda (name) (locate-dominating-file file name))
   names))

(defvar my-project-environment nil)
(defun my-vterm (arg)
  (interactive "P")
  (let ((shell "fish")
        (dominators '(".")))
    (pcase my-project-environment
      (`'nix
       (setq shell "nix develop -c fish"
             dominators '("flake.nix")))
      (`'mise
       (setq shell "mise en"
             dominators '("mise.local.toml" "mise.toml"))))
    (dlet ((vterm-shell shell)
           (default-directory (my-locate-dominating-files "." dominators)))
      (vterm arg))))

(provide 'my)

;;; my.el ends here
