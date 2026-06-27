;; Basic stuff to get package management working
(require 'package)
(add-to-list
 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Personal helper functions defined here
(use-package my :load-path "lisp/")

;; Changing some annoying default Emacs behavior
(setq
 custom-file (locate-user-emacs-file "custom.el")
 inhibit-startup-screen t
 make-backup-files nil
 auto-save-default nil
 sentence-end-double-space nil
 ring-bell-function 'ignore
 vc-follow-symlinks t)
(setq-default
 truncate-lines t
 indent-tabs-mode nil
 cursor-type 'bar
 electric-indent-inhibit t)
(global-display-line-numbers-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(load custom-file 'noerror)
(use-package delsel :hook (after-init . delete-selection-mode))

;; Cosmetic
(setq my-font-name-mono "IoskeleyMono Nerd Font")
(setq my-font-name-sans "Adwaita Sans")
(setq my-font-size 140)
(my-font-change-size 0)
(use-package modus-themes :ensure t)
(use-package standard-themes :ensure t)
(use-package ef-themes :ensure t)
(use-package doric-themes :ensure t)
(unless (bound-and-true-p custom-enabled-themes)
  (modus-themes-select 'standard-light))
(use-package spacious-padding
  :ensure t
  :config (spacious-padding-mode 1))
(use-package mo-line
  :load-path "lisp/"
  :config (setq-default mode-line-format mo-line))

;; Supercharging Emacs's defaults
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))
(use-package consult :ensure t)
(use-package marginalia
  :ensure t
  :config (marginalia-mode 1))
(use-package vertico
  :ensure t
  :config (vertico-mode 1))
(use-package vertico-directory
  :after vertico
  :bind
  (:map vertico-map
        ("C-<backspace>" . vertico-directory-delete-word)))

;; Things that make normal terminals/shells hard to use
(use-package vterm
  :ensure t
  :defer t)
(use-package tramp
  :defer t
  :custom (tramp-histfile-override t)
  :config (add-to-list 'tramp-remote-path 'tramp-own-remote-path))
(use-package compile
  :defer t
  :custom (compilation-scroll-output t))
(use-package dired
  :defer t
  :custom
  (dired-listing-switches "-alh --group-directories-first")
  (dired-dwim-target t)
  :hook (dired-mode . hl-line-mode))
(use-package exec-path-from-shell
  :ensure t
  :config (exec-path-from-shell-initialize))
(use-package envrc
  :ensure t
  :hook (after-init . envrc-global-mode))
(use-package magit
  :ensure t
  :defer t)
(use-package forge
  :after magit
  :ensure t
  :custom (auth-sources '("~/.ssh/authinfo")))
(use-package recentf
  :custom (recentf-max-saved-items 100)
  :config (recentf-mode 1))
(use-package etask :load-path "lisp/")

;; Things that make text editing less bad
(use-package cape :ensure t)
(use-package eglot
  :custom (eglot-autoshutdown t)
  :hook (prog-mode . eglot-ensure)
  :config
  (advice-add
   'eglot-completion-at-point
   :around #'cape-wrap-buster)
  (advice-add
   'eglot-completion-at-point
   :around #'cape-wrap-noninterruptible)
  :bind
  (:map eglot-mode-map
        ("C-c r" . 'eglot-rename)
        ("C-c f" . 'eglot-format)
        ("C-c a" . 'eglot-code-actions)))
(use-package corfu
  :ensure t
  :custom (corfu-auto t)
  :hook (prog-mode . corfu-mode)
  :bind (:map corfu-map ("RET" . nil)))
(use-package yasnippet
  :ensure t
  :custom (yas-prompt-functions '(yas-no-prompt))
  :config (yas-global-mode 1))
(use-package elec-pair
  :custom (electric-pair-skip-self nil)
  :hook (prog-mode . electric-pair-local-mode))
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; Languages I use
(use-package org
  :defer t
  :custom (org-edit-src-content-indentation 0))
(use-package zig-mode
  :ensure t
  :defer t
  :custom (zig-format-on-save nil))
(use-package typst-ts-mode
  :vc (:url "https://codeberg.org/meow_king/typst-ts-mode.git")
  :ensure t
  :defer t)
(my-install-languages
 auctex! cmake csv dockerfile fish haskell janet just kotlin-ts
 markdown meson nix tuareg! yaml)
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-langs
   '(go toml rust typescript tsx c java cpp typst kotlin))
  (treesit-auto-install t)
  :config
  (treesit-auto-install-all)
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; AI stuff
(use-package agent-shell
  :ensure t
  :defer t
  :bind (:map agent-shell-mode-map ("RET" . nil)))

;; Keybindings (I am evil)
;; Any keybindings I set above also work in vanilla Emacs
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(use-package evil
  :ensure t
  :custom
  (evil-undo-system 'undo-redo)
  (evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (evil-define-key
    '(normal motion visual) 'global
    (kbd "q") 'bury-buffer))
(use-package general
  :after evil
  :ensure t
  :config
  (general-create-definer leader-def :prefix "SPC")
  (leader-def
    :states '(normal motion visual)
    :keymaps 'override
    "SPC" #'execute-extended-command
    "u" #'universal-argument
    "k" #'kill-current-buffer
    "v" #'vterm
    "-" (lambda () (interactive) (my-font-change-size -10))
    "=" (lambda () (interactive) (my-font-change-size +10))
    "x" (my-key-prefix "C-x ")
    "f" (my-key-prefix "C-x C-")
    "c" (my-key-prefix "C-c ")
    "j" (my-key-prefix "C-c C-")
    "h" (my-key-prefix "C-h ")
    "p" (my-key-prefix "C-x p ")
    "g" #'etask-play
    "r" #'consult-ripgrep
    "b" #'consult-buffer
    "l" #'consult-line
    "a" #'my-arrange-windows
    "s" #'other-window
    "d" #'delete-window
    "e" #'envrc-reload))
(use-package evil-collection
  :after evil
  :ensure t
  :custom (evil-collection-repl-submit-state 'insert)
  :config (evil-collection-init))
(use-package transient
  :defer t
  :bind (:map transient-map ("<escape>" . transient-quit-one)))
