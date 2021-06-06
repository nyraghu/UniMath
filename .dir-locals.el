;;; Emacs directory variables for the project

((nil
  .
  ((eval
    .
    (defvar-local project:emacs-directory-name ".emacs"
      "Basename of the project Emacs settings directory."))
   (eval
    .
    (defvar-local project:root
      (locate-dominating-file default-directory
                              project:emacs-directory-name)
      "The top directory of the project."))
   (eval
    .
    (defvar-local project:emacs-directory
      (expand-file-name project:emacs-directory-name project:root)
      "Absolute path of the project Emacs settings directory."))
   (eval
    .
    (load (expand-file-name "common.el" project:emacs-directory)
          t nil t))))
 (coq-mode
  .
  ((eval
    .
    (load (expand-file-name "coq.el" project:emacs-directory)
          t nil t)))))

;;; End of file
