
(defvar tkdiff-file-list nil "TODO: File list")
(make-local-variable 'tkdiff-file-list)

(defun tkdiff (file-list)
  (interactive)
  (let ((buffer (get-buffer-create " *tkdiff-file-list*")))
    (switch-to-buffer buffer)
    (setq tkdiff-file-list file-list)
    (dolist (file-pair file-list)
      (let ((path (car file-pair)))
        (if (string-match "/google3/\\([^#]*\\)" path)
            (insert (match-string 1 path) "\n")
          (insert path "\n"))))))

(defun tkdiff-read-args-from-tmp-file (tmp-path)
  (interactive)
  (let ((raw-args
         (split-string (with-temp-buffer
                         (insert-file-contents tmp-path)
                         (buffer-string))))
        args file1 file2)
    (while raw-args
      (setq file1 (cadr raw-args))
      (setq file2 (caddr raw-args))
      (setq args (cons (cons file1 file2) args))
      (setq raw-args (cdddr raw-args)))
    ;(delete-file tmp-path)
    (reverse args)))

(tkdiff
 (tkdiff-read-args-from-tmp-file "/tmp/tmp.lAM6jJLqMt"))
