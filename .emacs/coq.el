;;; Project Emacs settings for Coq mode

(defvar-local coq:physical-root
  (expand-file-name "UniMath" project:root)
  "The root of the physical paths of the Coq modules of the project.")

(defvar-local coq:logical-root "UniMath"
  "The root of the logical names of the Coq modules of the project.")

;; Do not use a Coq project file to get options for `coqtop'.  They
;; are supplied below.
(setq-local coq-use-project-file nil)

;; Options for `coqtop' as mentioned above.
(setq-local coq-prog-args `("-Q" ,coq:physical-root ,coq:logical-root
                            "-emacs"
                            "-indices-matter"
                            "-noinit"
                            "-type-in-type"))

(defvar-local coq:tags-table
  (expand-file-name "TAGS" project:emacs-directory)
  "The tags table for the project.")

(defun coq:make-tags ()
  "Rebuild the project tags table and visit it."
  (interactive)
  (let ((default-directory project:emacs-directory))
    (let ((status (shell-command "make VERBOSE=1 tags")))
      (when (zerop status)
        (let ((tags-buffer (get-file-buffer coq:tags-table)))
          (when tags-buffer
            (with-current-buffer tags-buffer
              (revert-buffer t t))))
        (visit-tags-table coq:tags-table t)))))

(coq:make-tags)

;;; End of file
