;;; package --- init.el

;;; Commentary:
;;; This is my Emacs config, tuned for Go dev.

;;; Code:

;; Require Emacs package functionality.
(require 'package)

;; Add the Melpa repository to the list of package sources.
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

;; Initialize the package system.
(package-initialize)

;; List all packages.
(defvar package-list)
(setq package-list
      '(
        company-go
        color-theme-sanityinc-tomorrow
        crystal-mode
        evil
        exec-path-from-shell
        flycheck
        flycheck-crystal
        git-gutter
        go-mode
        go-eldoc
        helm
        magit
        use-package
        yasnippet
	))

;; Refresh package list.
(unless package-archive-contents
  (package-refresh-contents))


;; Install any missing packages.
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; Use fancy line number mode in Good Emacs Versions, and enable pixel scrolling.
(when (version<= "26.0.50" emacs-version )
  (require 'pixel-scroll)
  (pixel-scroll-mode 1)
  (global-display-line-numbers-mode)

  ;; Attempt to use cool title bar thing on Mac.
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . light)))


;; Load packages via use-package.
(require 'use-package)

;; Use Helm.
(use-package helm
  :defer t
  :init
  (helm-mode 1))

;; Use Evil Mode.
(use-package evil
  :init
  (evil-mode 1))

;; Use English even if my computer isn't in English
(set-language-environment "English")

;; Set the frame bar to have the same color as the current theme
(add-to-list 'default-frame-alist '(scroll-bar-background))

;; Magit setup
(use-package magit)

;; Enable tag HTML tag completion.
(setq sgml-quick-keys 'indent)

;; Read your $PATH properly on stupid macOS
(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-copy-env "GOPATH")
  (exec-path-from-shell-initialize))

;; Use YASnippet
(require 'yasnippet)
(yas-global-mode 1)

;; Tabs are 4 spaces in Go
(add-hook 'go-mode-hook '(lambda ()
                            (setq tab-width 4)))

;; Set default font
(set-face-attribute 'default nil
                     :family "Source Code Pro"
                     :height 130
                     :weight 'normal
                     :width 'normal)

;; Enable git gutter
(global-git-gutter-mode +1)

(require 'company)
(eval-after-load 'company
  '(progn
     (define-key company-active-map (kbd "TAB") 'company-select-next)
     (define-key company-active-map [tab] 'company-select-next)
     (define-key company-active-map (kbd "RET") 'company-complete-selection)))
(setq-default company-selection-wrap-around t)
(setq-default company-minimum-prefix-length 1)
(setq company-tooltip-limit 20)
(setq company-idle-delay .3)
(setq company-echo-delay 0)
(setq company-begin-commands '(self-insert-command))

;; Go setup
(require 'company-go)
(require 'go-eldoc)
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)
(add-hook 'go-mode-hook 'go-eldoc-setup)
(add-hook 'go-mode-hook 'company-mode)
(add-hook 'go-mode-hook (lambda ()
			  (set
			   (make-local-variable 'company-backends) '(company-go))
			  (company-mode)))

;; Lisp setup
(add-hook 'emacs-lisp-mode-hook 'company-mode)

;; Delete trailing spaces on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Theme setup
(load-theme 'sanityinc-tomorrow-night t)

;; Get rid of the custom stuff that everyone hates
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; And that's it!
(provide 'init)

;;; init.el ends here
