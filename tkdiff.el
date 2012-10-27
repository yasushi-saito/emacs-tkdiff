
(defvar tkdiff-file-list nil "TODO: File list")
(make-local-variable 'tkdiff-file-list)

(defvar tkdiff-file-list-map (make-keymap))
(define-key tkdiff-file-list-map "n" 'next-line)
(define-key tkdiff-file-list-map "p" 'previous-line)
(define-key tkdiff-file-list-map "\C-m" 'tkdiff-start-diff)
(define-key tkdiff-file-list-map " " 'tkdiff-start-diff)

(defun tkdiff (file-list)
  (interactive)
  (let ((buffer (get-buffer-create " *tkdiff-file-list*")))
    (switch-to-buffer buffer)
    (setq tkdiff-file-list file-list)
    (setq buffer-read-only nil)
    (erase-buffer)
    (dolist (file-pair file-list)
      (let ((path (car file-pair)))
        (if (string-match "/google3/\\([^#]*\\)" path)
            (insert (match-string 1 path) "\n")
          (insert path "\n"))))
    (setq buffer-read-only t)
    (use-local-map tkdiff-file-list-map)
    (goto-char (point-min))))

(defun tkdiff-start-diff ()
  (interactive)
  (save-excursion
    (let* ((line (count-lines 1 (point)))
	   (file-pair (nth line tkdiff-file-list)))
      (ediff-files (car file-pair) (cdr file-pair)))))

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

(tkdiff '(("testdata/file1.txt" . "testdata/file1.new.txt")))
;(tkdiff
; (tkdiff-read-args-from-tmp-file "/tmp/tmp.lAM6jJLqMt"))
