;;; ============================================================
;;; BOOTSTRAP
;;; ============================================================

;;; Custom variables file
(setq-default custom-file (concat user-emacs-directory "custom.el"))
(if (file-exists-p custom-file)
    (load-file custom-file))

;;; Increase GC threshold for faster startup
(setq gc-cons-threshold (* 64 1024 1024))

;;; Restore to 64mb after startup
;(add-hook 'emacs-startup-hook
;          (lambda ()
;            (setq gc-cons-threshold (* 64 1024 1024))))

(defun display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'display-startup-time)

;;; Package manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;;; use-package
(if (version< emacs-version "29")
    (unless (package-installed-p 'use-package)
      (package-install 'use-package)))
(setq use-package-always-ensure t
      use-package-expand-minimally t)


;;; ============================================================
;;; CORE
;;; ============================================================

;;; PATH — add common shell dirs that GUI Emacs misses, plus ghcup
(use-package exec-path-from-shell
  :config
  (when (display-graphic-p)
    (exec-path-from-shell-initialize)))

;;; Backups
(defconst backup-dir
  (concat user-emacs-directory "backup/"))
(setq backup-directory-alist `(("." . ,backup-dir))
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 10
      kept-old-versions 10)

;;; Recently opened files
(recentf-mode 1)
(setq recentf-max-menu-items 100)
(setq recentf-max-saved-items 100)

;;; Remember history
(setq history-length 25)
(savehist-mode 1)

;;; Remember cursor position
(save-place-mode 1)

;;; Auto-revert buffers on external changes
(use-package autorevert
  :ensure nil
  :config
  (global-auto-revert-mode +1)
  (setq auto-revert-interval 2
        auto-revert-check-vc-info t
        global-auto-revert-non-file-buffers t
        auto-revert-verbose nil))

;;; Editing behaviour
(setq ring-bell-function 'ignore)
(setq scroll-step 1)
(setq scroll-conservatively most-positive-fixnum)
(setq inhibit-startup-screen t)
(setq ispell-dictionary "en_GB")
(setq org-support-shift-select t)
(setq-default indent-tabs-mode nil
              c-basic-offset 2
              tab-width 2
              c-default-style "modified-stroustrup")
(setq whitespace-line-column 120)
(setq frame-title-format '(buffer-file-name "Emacs: %b (%f)" "Emacs: %b"))
(setq column-number-mode t)
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program (or (getenv "BROWSER")
                                     (executable-find "xdg-open")
                                     "xdg-open"))
(cua-mode)
(global-display-line-numbers-mode)
(add-hook 'org-mode-hook #'visual-line-mode)
(add-hook 'prog-mode-hook #'whitespace-mode)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;; C style
(c-add-style "modified-stroustrup"
             '("stroustrup"
               (c-basic-offset . 2)
               (tab-width . 2)
               (c-offsets-alist
                (innamespace . 0))))

;;; Hide useless buffers when cycling
(defvar buffers-not-to-ignore
  '("*eat*" "*shell*" "*ielm*" "*eww*" "*terminal*" "*ansi-term*" "*eshell*" "*Dictionary*"))
(defun ignore-useless-buffers ()
  (set-frame-parameter (selected-frame) 'buffer-predicate
                       (lambda (buf) (or (member (buffer-name buf) buffers-not-to-ignore)
                                         (not (string-match-p "^*" (buffer-name buf)))))))
(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (with-selected-frame frame
                  (ignore-useless-buffers))))
  (ignore-useless-buffers))

;;; Helpers
(defun open-init-file ()
  "Open the main Emacs init file."
  (interactive)
  (find-file user-init-file))

(defun rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))

;;; Completion
(use-package vertico
  :config (vertico-mode))

(use-package orderless
  :config
  (setq completion-styles '(orderless basic)))

(use-package marginalia
  :config (marginalia-mode))

;; (use-package smex
;;   :config (global-set-key (kbd "M-x") 'smex))
;; (ido-mode 1)
;; (setq ido-auto-merge-work-directories-length -1)
;; (define-key ido-file-completion-map (kbd "SPC") #'self-insert-command)

(use-package which-key
  :config (which-key-mode))

;;; Keybindings
(global-set-key (kbd "C-S-d") 'duplicate-line)
(global-set-key (kbd "C-<tab>") 'next-buffer)
(global-set-key (kbd "C-<iso-lefttab>") 'previous-buffer)
(global-set-key (kbd "C-x C-S-s") 'rename-file-and-buffer)
(global-set-key (kbd "C-t") (lambda () (interactive) (term "zsh")))
(global-set-key (kbd "C-1") 'comment-or-uncomment-region)
(global-set-key (kbd "C-, C-e") 'flymake-show-buffer-diagnostics)
(global-unset-key (kbd "C-w"))
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-w") 'kill-current-buffer)
(global-set-key (kbd "C-, <right>") 'windmove-right)
(global-set-key (kbd "C-, <left>")  'windmove-left)
(global-set-key (kbd "C-, <up>")    'windmove-up)
(global-set-key (kbd "C-, <down>")  'windmove-down)

;;; Editing packages
(use-package multiple-cursors
  :bind (("C-S-<up>"       . mc/mark-previous-like-this)
         ("C-S-<down>"     . mc/mark-next-like-this)
         ("C-M-<mouse-1>"  . mc/add-cursor-on-click))
  :config
  (global-unset-key (kbd "C-<mouse-1>")))

(use-package drag-stuff
  :config
  (drag-stuff-define-keys)
  (drag-stuff-global-mode 1))

;;; Themes
(setq custom-safe-themes t)
(add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes/"))
(load-theme 'electric-ice-darker t)

;;; ============================================================
;;; GUI
;;; ============================================================

(when (display-graphic-p)

  ;;; UI tweaks
  (add-to-list 'default-frame-alist '(fullscreen . maximized))
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (set-window-scroll-bars (minibuffer-window) 0 'none)

  ;;; Font
  (add-to-list 'default-frame-alist '(font . "CascadiaCode 12"))
  (setq font-lock-maximum-decoration 2)

  ;;; Themes 2
  (defun disable-all-themes ()
    "Disable all active themes."
    (dolist (i custom-enabled-themes)
      (disable-theme i)))
  (advice-add 'load-theme :before (lambda (&rest _) (disable-all-themes)))

  (use-package dracula-theme :defer t)
  (use-package nord-theme    :defer t)

  ;;; Dashboard
  (use-package dashboard
    :config
    (setq dashboard-projects-backend          'projectile
          dashboard-startup-banner            'logo
;          dashboard-startup-banner            "~/Pictures/lain6.jpg"
          dashboard-center-content            t
          dashboard-image-banner-max-height   350
          dashboard-image-banner-max-width    500
          dashboard-path-max-length           60
          dashboard-path-style                'truncate-beginning
          dashboard-items                     '((recents   . 10)
                                                (projects  . 5)
                                                (bookmarks . 5))
          dashboard-bookmarks-switch-function #'find-file)
    (with-eval-after-load 'projectile
      (dashboard-setup-startup-hook)))

  (add-hook 'server-after-make-frame-hook
            (lambda ()
              (when (string= (buffer-name) "*scratch*")
                (scratch-buffer))))

  ;;; Project manager
  (use-package projectile
    :config
    (define-key projectile-mode-map (kbd "C-p") 'projectile-command-map)
    (projectile-mode))

  ;;; Fuzzy find
  (use-package fzf
    :config
    (global-unset-key (kbd "C-f"))
    (defun fzf-at-project-root ()
      "Open fzf at project root, or current directory if not in a project."
      (interactive)
      (fzf-find-file-in-dir (if-let ((proj (project-current)))
                                (project-root proj)
                              default-directory)))
    (global-set-key (kbd "C-f") 'fzf-at-project-root))

  ;;; Git
  (use-package magit :defer t)

  ;;; Completion
  (use-package company
    :config
    (add-hook 'after-init-hook 'global-company-mode)
    (setq company-minimum-prefix-length 2))

  ;;; Folding
  (use-package yafolding
    :hook (prog-mode . yafolding-mode)
    :config
    (global-set-key (kbd "C-, C-s")   'yafolding-show-parent-element)
    (global-set-key (kbd "C-, C-h")   'yafolding-hide-parent-element)
    (global-set-key (kbd "C-, s")     'yafolding-show-element)
    (global-set-key (kbd "C-, h")     'yafolding-hide-element)
    (global-set-key (kbd "C-, C-S-s") 'yafolding-show-all)
    (global-set-key (kbd "C-, C-S-h") 'yafolding-hide-all))

  ;;; LSP
  (use-package lsp-mode
    :hook ((python-ts-mode . lsp)
           (c-ts-mode      . lsp)
           (c++-ts-mode    . lsp))
    :config
    (setq lsp-clients-clangd-args '("--header-insertion=never")))

  (use-package lsp-ui
    :defer t
    :config
    (setq lsp-ui-doc-enable            t
          lsp-ui-doc-show-with-cursor  t
          lsp-ui-doc-show-with-mouse   nil
          lsp-ui-sideline-enable       nil))

  ;;; Language modes

  ;; Python
  (use-package lsp-pyright
    :defer t
    :config
    (defun set-python-format-keybinding ()
      (local-set-key (kbd "C-, f") #'lsp-format-buffer))
    (add-hook 'python-ts-mode-hook 'set-python-format-keybinding)
    (setq python-indent-offset 2))

  ;; Haskell
  (use-package lsp-haskell :defer t)
  (use-package haskell-mode
    :defer t
    :config
    (add-hook 'haskell-mode-hook #'lsp)
    (add-hook 'haskell-literate-mode-hook #'lsp)
    (add-hook 'haskell-mode-hook #'interactive-haskell-mode))

  (use-package ormolu
    :defer t
    :hook (haskell-mode . ormolu-format-on-save-mode)
    :bind (:map haskell-mode-map
                ("C-, C-f" . ormolu-format-buffer))
    :config (setq ormolu-process-path "fourmolu"))

  ;; C/C++
  (use-package clang-format
    :defer t
    :config
    (defun set-clang-format-keybinding ()
      (local-set-key (kbd "C-, f") 'clang-format-buffer))
    (add-hook 'c-ts-mode-hook   'set-clang-format-keybinding)
    (add-hook 'c++-ts-mode-hook 'set-clang-format-keybinding))

  ;; Other languages
  (add-hook 'go-ts-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 2)))
  (use-package tuareg      :defer t)  ; OCaml
  (use-package ocaml-eglot
    :defer t
    :after tuareg
    :hook (tuareg-mode . ocaml-eglot-setup))
  (use-package ocp-indent  :defer t)
  (use-package racket-mode :defer t)
  (use-package bison-mode  :defer t)
  (use-package cmake-mode  :defer t :mode ("CMakeLists.txt" . cmake-mode))
  (use-package meson-mode  :defer t :mode ("meson.build" . meson-mode))

  (use-package treesit-auto
    :config
    (setq treesit-auto-install 'prompt)
    (global-treesit-auto-mode)
    (treesit-auto-add-to-auto-mode-alist 'all))

  ;; Misc
  (use-package latex-preview-pane :defer t)
  (use-package nov
    :defer t
    :mode ("\\.epub\\'" . nov-mode))

) ; end (when (display-graphic-p))
