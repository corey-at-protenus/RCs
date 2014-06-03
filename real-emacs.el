(setq message-log-max t)
(add-to-list 'load-path "~/.emacs.d")

(setq package-enable-at-startup nil)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(add-to-list 'load-path "~/.emacs.d/evil")
(add-to-list 'load-path "~/.emacs.d/evil-tabs")

(require 'evil)
(require 'evil-tabs)

;; default text formatting options
(setq-default indent-tabs-mode nil)
(setq make-backup-files nil)
(setq-default fill-column 101)

(add-hook 'after-change-major-mode-hook
          (function
            (lambda ()
                (fci-mode)
                (turn-on-auto-fill)
            )
          )
)

;; ruby 

(add-hook 'ruby-mode-hook
  (function (lambda ()
              ; (setq evil-shift-width ruby-indent-level)
              ; (evil-define-key 'insert 
              ;                  ruby-mode-map
              ;                  (kbd "C-n")
              ;                  'rsense-complete
              ;   )
            )
  )
)

(setq auto-mode-alist (cons '("\\.rake\\'" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Rakefile" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("Gemfile" . ruby-mode) auto-mode-alist))

; use rsense autocomplete for C-n in insert

; C
(setq-default c-indent-level 4)

; keyboard interface options
(evil-mode 1)
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-evil-tabs-mode t)

(setq scroll-conservatively 5)
(setq scroll-margin 5)

; GUI options
(add-to-list 'default-frame-alist  '(width . 100) )
(require 'fill-column-indicator)

(load-theme 'solarized-dark t)

; plugins
(autoload 'coq-mode "ProofGeneral" "~/.emacs.d/ProofGeneral/generic/proof-site.el"
  "ProofGeneral for coq")

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(coq-prog-args (quote ("-I" "/home/corey/Development/cpdt_coconnor/cpdt/src")))
 '(ecb-auto-activate t)
 '(ecb-display-default-dir-after-start t)
 '(ecb-fix-window-size (quote width))
 '(ecb-layout-name "dironly")
 '(ecb-layout-window-sizes (quote (("basic" (ecb-directories-buffer-name 0.25728155339805825 . 0.48214285714285715) (ecb-analyse-buffer-name 0.25728155339805825 . 0.5)) ("left8" (ecb-directories-buffer-name 0.1796116504854369 . 0.26785714285714285) (ecb-sources-buffer-name 0.1796116504854369 . 0.25) (ecb-methods-buffer-name 0.1796116504854369 . 0.2857142857142857) (ecb-history-buffer-name 0.1796116504854369 . 0.17857142857142858)))))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
 '(ecb-show-sources-in-directories-buffer (quote always))
 '(ecb-tip-of-the-day nil)
 '(ecb-windows-width 40)
 '(inhibit-startup-screen t)
 '(nav-width 40))

(setq auto-mode-alist (cons '("\\.v$" . coq-mode) auto-mode-alist))
(autoload 'coq-mode "coq" "Major mode for editing Coq vernacular." t)

(autoload 'markdown-mode "~/.emacs.d/markdown-mode/markdown-mode.el"
   "Major mode for editing Markdown files" t)

(setq auto-mode-alist
   (cons '("\\.md" . markdown-mode) auto-mode-alist))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(when (file-readable-p "~/.emacs-local.el")
  (load-file "~/.emacs-local.el")
)

(setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
                                  global-semanticdb-minor-mode
                                  global-semantic-idle-summary-mode
                                  global-semantic-mru-bookmark-mode))
(semantic-mode 1)

(autoload 'dirtree "dirtree" "dirtree" t)

(setq inhibit-default-init t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

(add-to-list 'load-path "~/.emacs.d/jdee-2.4.1/lisp")
(autoload 'java-mode "jde.el"
  "JDEE for java" t)

(autoload 'nav "nav" "nav" t)
(eval-after-load 'nav
  '(progn
      (nav-disable-overeager-window-splitting)
      (evil-make-overriding-map nav-mode-map 'normal t)
      (evil-define-key 'normal nav-mode-map
        "j" 'evil-next-line
        "k" 'evil-previous-line)))

(eval-after-load 'compilation-mode
  '(progn
    (evil-make-overriding-map compilation-mode 'normal t)
    (evil-define-key 'normal nav-mode-map
      "gt" 'elscreen-next
      "gT" 'elscreen-previous)))

; fuck this shit. doesn't work at all
(defun compilation-mode-longlines-hook ()
  "Set visual-line-mode when entering compilation mode."
  (longlines-mode t))

(add-hook 'compilation-mode-hook 'compilation-mode-longlines-hook)

; enable visual-line-mode by default cause the above doesn't work
(setq-default global-visual-line-mode t)
; which also doesn't work
; I think emacs has just bit rotted into uselessness....
