;;; mo-line.el --- A personal mode-line -*- lexical-binding: t; -*-

;; Usage:
;; (setq-default mode-line-format mo-line)

(defun mo-line--state-bg ()
  (face-attribute
   (if (mode-line-window-selected-p)
       'font-lock-keyword-face
     'mode-line-inactive)
   :foreground))

(defun mo-line--state-fg ()
  (face-attribute
   (if (mode-line-window-selected-p)
       'default
     'mode-line-inactive)
   :background))

(defun mo-line--state-symbol ()
  (cond
   ((not (bound-and-true-p evil-mode)) "")
   ((evil-normal-state-p) " <N> ")
   ((evil-replace-state-p) " <R> ")
   ((evil-motion-state-p) " <M> ")
   ((evil-operator-state-p) " <O> ")
   ((evil-visual-state-p) " <V> ")
   ((evil-visual-state-p) " <V> ")
   ((evil-insert-state-p) " <I> ")
   (t " <E> ")))

(defun mo-line--state-indicator ()
  (propertize
   (mo-line--state-symbol)
   'face
   (list ':background (mo-line--state-bg)
         ':foreground (mo-line--state-fg)
         ':box `(:line-width 1 :color ,(mo-line--state-bg)))))

(defun mo-line--dirty-buffer-indicator ()
  (if (and buffer-file-name (buffer-modified-p))
      (propertize " *" 'face 'error)
    ""))

(defun mo-line--zoom-value ()
  (if (and (display-graphic-p)
           (not (zerop text-scale-mode-amount)))
      (concat
       (if (> text-scale-mode-amount 0) " +" " ")
       (number-to-string text-scale-mode-amount))
    ""))

(defun mo-line--zoom-indicator ()
  (propertize (mo-line--zoom-value) 'face 'success))

(defun mo-line--mode-string-unformatted ()
  (substring (symbol-name major-mode) 0 -5))

(defun mo-line--mode-string-formatted ()
  (capitalize
   (string-replace "-" " " (mo-line--mode-string-unformatted))))

(defun mo-line--mode-indicator ()
  (format "(%s)" (mo-line--mode-string-formatted)))

(defconst mo-line
  '("%e"
    (:eval (mo-line--state-indicator))
    (:eval (propertize (format " %s" (buffer-name)) 'face 'bold))
    (:eval (mo-line--dirty-buffer-indicator))
    (:eval (mo-line--zoom-indicator))
    mode-line-format-right-align
    (:eval (mo-line--mode-indicator))
    (:eval (if (bound-and-true-p eglot--managed-mode) "[LSP] " " "))))

(provide 'mo-line)

;;; mo-line.el ends here
