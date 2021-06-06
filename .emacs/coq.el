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

;;; End of file
