;; configuration of modes

(setq-default indent-tabs-mode nil
              tab-width 4
              c-basic-offset 4
              c-indent-level 4
              fill-column 101)

(electric-indent-mode 1)

(use-package nix-mode
             :mode ("nix" . nix-mode)
             :config
             (progn
               (add-hook 'nix-mode-hook
                         (lambda ()
                           (setq-local evil-shift-width 2)
                           (setq-local tab-width 2)
                           (setq-local c-basic-offset 2)
                           (setq-local indent-line-function 'insert-tab)
                           (setq-local indent-line-function 'indent-relative)
                           )
                         )
               )
             )

(eval-after-load 'haskell-mode
  (add-hook 'haskell-mode-hook
            (lambda ()
              (turn-on-haskell-indentation)
              (haskell-indentation-enable-show-indentations)))
  )

(eval-after-load 'gdscript-mode
  (add-hook 'gdscript-mode-hook
            (lambda ()
              (setq-local evil-shift-width 4)
              (setq-local tab-width 4)
              (setq-local c-basic-offset 4)
              (setq-local indent-line-function 'insert-tab)
              (setq-local tabs-always-indent t)
              )
            )
  )

(defun scalafmt-scala-format ()
  (setq-local tab-width 2)
  (setq-local c-basic-offset 2)
  (setq-local evil-shift-width 2)
  (setq-local scala-indent:align-parameters t)
  )

(use-package scala-mode
  :ensure t
  :after (:all flycheck-mode lsp-ui)
  :interpreter ("scala" . scala-mode)
  :config
  (progn
    (require 'lsp-scala)
    (add-hook 'scala-mode-hook 'cleanup-on-save)
    (add-hook 'scala-mode-hook 'scalafmt-scala-format)
    (add-hook 'scala-mode-hook 'flycheck-mode)
    )
  )

(use-package sbt-mode
  :ensure t
  )

(use-package flycheck
  :ensure t
  :config
  (progn
    (global-flycheck-mode)
    )
  )

(use-package lsp-mode
  :ensure t
  :config
  (progn
    (setq-default lsp-scala-server-command '("metals" "0.2.0-SNAPSHOT"))
    )
  )

(eval-after-load 'js-mode
  (add-hook 'js-mode-hook
            (lambda ()
              (setq-local js-indent-level 2)
              (setq-local tab-width 2)
              (setq-local c-basic-offset 2)
              (setq-local evil-shift-width 2)
              (cleanup-on-save)
              )))

(eval-after-load 'js-mode
  (add-hook 'js-mode-hook
            (lambda() (cleanup-on-save))))

(eval-after-load 'haml-mode
  (add-hook 'haml-mode-hook
            (lambda ()
              (setq-local electric-indent-chars (remq ?\n electric-indent-chars))))
  )

;; ruby
(eval-after-load 'ruby-mode
 '(progn
    (setq-default ruby-indent-level 2)
    (add-hook 'ruby-mode-hook
      (lambda () (setq-local evil-shift-width ruby-indent-level)))
    (add-hook 'ruby-mode-hook
      (lambda () (cleanup-on-save)))))

(setq auto-mode-alist (cons '("\\.rake\\'" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Rakefile" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Gemfile" . ruby-mode) auto-mode-alist))

(provide 'configure-modes)
