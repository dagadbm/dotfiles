(defconst aj-javascript-packages
  '(
    add-node-modules-path
    company-flow
    eslintd-fix
    flycheck
    prettier-js
    tide
    rjsx-mode))


(defun aj-javascript/init-eslintd-fix ()
  (use-package eslintd-fix
    :defer t
    :commands eslintd-fix-mode
    :init
    (progn
      (add-hook 'rjsx-mode-hook #'eslintd-fix-mode t))))

(defun aj-javascript/init-rjsx-mode ()
  (use-package rjsx-mode
    :defer t
    :init
    (progn
      (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . rjsx-mode))

      (setq
       js2-mode-show-strict-warnings nil
       js2-mode-show-parse-errors nil
       js-indent-level 2
       js2-basic-offset 2
       js2-strict-trailing-comma-warning nil
       js2-strict-missing-semi-warning nil)

      (advice-add #'js-jsx-indent-line
                  :after
                  #'aj-javascript/js-jsx-indent-line-align-closing-bracket)
      (add-hook 'rjsx-mode-hook #'aj-javascript/eslintd-set-flycheck-executable t))
    :config
    (define-key rjsx-mode-map "<" nil)
    (define-key rjsx-mode-map (kbd "C-d") nil)
    (define-key rjsx-mode-map ">" nil)
    (modify-syntax-entry ?_ "w" js2-mode-syntax-table)))

(defun aj-javascript/post-init-add-node-modules-path ()
  (with-eval-after-load 'rjsx-mode
    (add-hook 'rjsx-mode-hook #'add-node-modules-path)))

(defun aj-javascript/post-init-company-flow ()
  (spacemacs|add-company-backends
    :backends
    '((company-flow :with company-dabbrev-code)
      company-files)))

(defun aj-javascript/post-init-flycheck ()
  (with-eval-after-load 'flycheck
    (push 'javascript-jshint flycheck-disabled-checkers)
    (push 'json-jsonlint flycheck-disabled-checkers))

  (spacemacs/enable-flycheck 'rjsx-mode))

(defun aj-javascript/post-init-tide ()
  (with-eval-after-load 'tide
    ;; (flycheck-add-mode 'javascript-tide 'rjsx-mode)
    ;; (flycheck-add-next-checker 'javascript-tide 'javascript-eslint)

    ;; (flycheck-add-next-checker 'javascript-eslint 'jsx-tide 'append)
    ;; (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)
    (flycheck-add-next-checker 'javascript-eslint 'javascript-tide 'append)
    )

    (with-eval-after-load 'rjsx-mode
        (add-hook 'rjsx-mode-hook #'aj-javascript/setup-tide-mode)

        (spacemacs/set-leader-keys-for-major-mode 'rjsx-mode
            "g" 'tide-jump-to-definition
            "b" 'tide-jump-back
            "r" 'tide-references
            "R" 'tide-rename-symbol
            "O" 'tide-organize-imports
            "V" 'tide-verify-setup)))

(defun aj-javascript/init-prettier-js ()
  (use-package prettier-js
    :defer t
    :init
    (progn
      (add-hook 'rjsx-mode-hook 'prettier-js-mode)
      (setq
        prettier-js-width-mode nil
        prettier-js-args '("--print-width" "120"
                           "--single-quote")))))
