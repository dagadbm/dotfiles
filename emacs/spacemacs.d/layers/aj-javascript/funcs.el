(defun aj-javascript/eslintd-set-flycheck-executable ()
  (interactive)
  (when-let (eslintd-executable (executable-find "eslint_d"))
    (make-variable-buffer-local 'flycheck-javascript-eslint-executable)
    (setq flycheck-javascript-eslint-executable eslintd-executable)))

;; Inspired by http://blog.binchen.org/posts/indent-jsx-in-emacs.html
(defun aj-javascript/js-jsx-indent-line-align-closing-bracket ()
  "Workaround sgml-mode and align closing bracket with opening bracket"
  (save-excursion
    (beginning-of-line)
    (when (looking-at-p "^ +\/?> *$")
      (delete-char sgml-basic-offset))))

(defun aj-javascript/setup-tide-mode ()
    (interactive)
    (tide-setup)
    (flycheck-mode +1)
    (eldoc-mode +1)
    (company-mode +1)
    (tide-hl-identifier-mode +1)

    (setq
        flycheck-check-syntax-automatically '(save mode-enabled)

        tide-format-options '(:indentSize 2 :indentStyle 2 :tabSize 2 :ConvertTabsToSpaces t)
        tide-tsserver-executable "~/.nvm/versions/node/v8.11.1/bin/tsserver"
        tide-completion-detailed t
        tide-always-show-documentation t
        )
    )
