;;; zucchini.el --- Per project keybindings and task runner -*- lexical-binding: t; -*-

(defvar zucchini--tasks nil)
(defvar zucchini-project-directory nil)

(defun zucchini--separate-tasks (lst)
  (if lst
      (let ((head (car lst))
            (tail (zucchini--separate-tasks (cdr lst))))
        (if (vectorp head)
            (cons nil (cons (cons head (car tail)) (cdr tail)))
          (cons (cons head (car tail)) (cdr tail))))
    (cons nil nil)))

(defmacro zucchini-register (&rest args)
  (let ((tasks (zucchini--separate-tasks args)))
    (when (car tasks) (error "Should begin with a key"))
    `(progn
       ,@(mapcar
          (lambda (task) `(add-to-list 'zucchini--tasks ',task))
          (cdr tasks)))))

(defun zucchini-play ()
  (interactive)
  (setq zucchini--tasks nil)
  (let ((project-directory (locate-dominating-file "." ".zucchini.el")))
    (unless project-directory (error ".zucchini.el not found"))
    (load-file (file-name-concat project-directory ".zucchini.el"))
    (let* ((event (read-event))
           (description (single-key-description event))
           (symbol (intern description))
           (key (vector symbol))
           (task (assoc key zucchini--tasks 'equal)))
      (unless task (error "No task for %s" key))
      (dlet ((zucchini-project-directory project-directory))
        (funcall `(lambda () ,@(cdr task)))))))

(defun zucchini-compile (command)
  (dlet ((default-directory zucchini-project-directory))
    (select-window
     (get-buffer-window
      (compile command)))))

(provide 'zucchini)

;;; zucchini.el ends here 
