;;; etask.el --- Per project task runner and keybindings -*- lexical-binding: t; -*-

(defvar etask--tasks nil)
(defvar etask-project-directory nil)

(defun etask--separate-tasks (lst)
  (if lst
      (let ((head (car lst))
            (tail (etask--separate-tasks (cdr lst))))
        (if (vectorp head)
            (cons nil (cons (cons head (car tail)) (cdr tail)))
          (cons (cons head (car tail)) (cdr tail))))
    (cons nil nil)))

(defmacro etask-register (&rest args)
  (let ((tasks (etask--separate-tasks args)))
    (when (car tasks) (error "Should begin with a key"))
    `(progn
       ,@(mapcar
          (lambda (task) `(add-to-list 'etask--tasks ',task))
          (cdr tasks)))))

(defun etask-play ()
  (interactive)
  (setq etask--tasks nil)
  (let ((project-directory (locate-dominating-file "." ".etask.el")))
    (unless project-directory (error ".etask.el not found"))
    (load-file (file-name-concat project-directory ".etask.el"))
    (let* ((event (read-event))
           (description (single-key-description event))
           (symbol (intern description))
           (key (vector symbol))
           (task (assoc key etask--tasks 'equal)))
      (unless task (error "No task for %s" key))
      (dlet ((etask-project-directory project-directory))
        (funcall `(lambda () ,@(cdr task)))))))

(defun etask-compile (command)
  (dlet ((default-directory etask-project-directory))
    (select-window
     (get-buffer-window
      (compile command)))))

(provide 'etask)

;;; etask.el ends here
