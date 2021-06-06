;;; Project Emacs settings common to all major modes

;; Use the `UTF-8' coding system for buffers in this project.
(set-language-environment "UTF-8")

;; Use the `Agda' input for typing characters in buffers.
(when (featurep 'agda-input)
  (activate-input-method "Agda"))

;;; End of file
