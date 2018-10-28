;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

;; Increase gc-cons-threshold, depending on your system you may set it back to a
;; lower value in your dotfile (function `dotspacemacs/user-config')
(setq gc-cons-threshold 100000000)

(defconst spacemacs-version         "0.200.13" "Spacemacs version.")
(defconst spacemacs-emacs-min-version   "24.4" "Minimal version of Emacs.")

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  (load-file (concat (file-name-directory load-file-name)
                     "core/core-load-paths.el"))
  (require 'core-spacemacs)
  (spacemacs/init)
  (configuration-layer/sync)
  (spacemacs-buffer/display-startup-note)
  (spacemacs/setup-startup-hook)
  (require 'server)
  (unless (server-running-p) (server-start)))
  
;; ////////////////////////////////// NEW /////////////////////////////////////////

(package-initialize)
(require 'org)
(setq org-confirm-babel-evaluate nil)  ;; evaluate src block without confirmation

;;;;;;; [2015-01-22 Thu 21:27]
(defvar endless/init.org-message-depth 5
  "What depth of init.org headers to message at startup.")

(with-temp-buffer
  (insert-file "~/git/.emacs.d/yt/init.org")
  (goto-char (point-min))

  ;; org babels
  (search-forward "\n* Babel Library")
  (org-copy-subtree)
  (let ((tmp-file (make-temp-file "tmp")))
    (with-temp-file tmp-file (yank))
    (org-babel-lob-ingest tmp-file))

  ;; emacs lisp functions
  (goto-char (point-min))
  (search-forward "\n* Emacs Configuration")
  (while (not (eobp))
    (forward-line 1)
    (cond
     ;; Report Headers
     ((looking-at
       (format "\\*\\{2,%s\\} +.*$"
               endless/init.org-message-depth))
      (message "%s" (match-string 0)))
      ;; (message (format (current-time-string))))
     ;; Evaluate Code Blocks
     ((looking-at "[\s]*\\#\\+begin_src\semacs-lisp")
      ;; ((looking-at "#\\+BEGIN_SRC +emacs-lisp.*$")
      ;; ((looking-at "^#\\+BEGIN_SRC +.*$")
      (org-babel-execute-src-block))
     ;; Finish on the next level-1 header
     ((looking-at "^\\* End")
      (goto-char (point-max))))))
	  
(setq my-package-list '(ess
                        ssh
                        auto-complete
                        nyan-mode
                        yasnippet
                        projectile
                        magit
                        helm-swoop
                        nyan-mode
                        org-jekyll
                        org-plus-contrib
                        helm-projectile
                        rainbow-delimiters
                        zenburn-theme
                        htmlize
                        nanowrimo
                        golden-ratio
                        artbollocks-mode
                        langtool
                        flycheck
                        expand-region
                        guide-key
                        exec-path-from-shell
                        smart-mode-line
                        smart-mode-line-powerline-theme
                        powerline
                        synosaurus
                        hydra
                        w3m
                        ace-window
                        calfw
                        multiple-cursors
                        org-download
                        paradox
                        smartparens
                        ace-jump-mode
                        voca-builder
                        org-download
                        gist
                        sunshine
                        keyfreq
                        pretty-mode
                        f
                        olivetti
                        helm-mu
                        ))

(require 'package)
(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))
;; install
(dolist (i-package my-package-list)
  (unless (package-installed-p i-package)
    (package-install i-package)))

;; ref: http://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files
;; save all backup files (foo~) to this directory.
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      auto-save-timeout 20   ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200 ; number of keystrokes between auto-saves (default: 300)
      )

;; guide-key package
(require 'guide-key)
(setq guide-key/guide-key-sequence t) ;; on for all key-bindings
(guide-key-mode 1)

;; start auto-complete with emacs
(require 'auto-complete)
;; do default config for auto-complete
(require 'auto-complete-config)
(ac-config-default)

(recentf-mode 1)
(setq recentf-max-saved-items 200
      recentf-max-menu-items 15)
(setq inhibit-startup-message t)        ; Disable startup message

(setq visible-bell t)

;; (require 'yasnippet)
;; (yas-global-mode 1)
;; (setq yas-snippet-dirs '("~/git/.emacs.d/my-snippets"
;;                          "~/git/.emacs.d/.cask/24.4.2/elpa/yasnippet-20141102.1554/snippets"
;;                          "~/git/.emacs.d/.cask/25.0.50.1/elpa/yasnippet-20141102.1554/snippets"))

(require 'ace-window)
(global-set-key (kbd "<f1>") 'ace-window)
(setq aw-scope 'frame)

(require 'golden-ratio)
(golden-ratio-mode 1)
(add-to-list 'golden-ratio-extra-commands 'ace-window) ;; active golden ratio when using ace-window

(defun yt/ref-frame ()
  (interactive)
  ;;   (frame-parameter (car (frame-list)) 'name)
  (if (eq 1 (length (frame-list)))
      (new-frame '((name . "***********************REFERENCE*******************")))
    nil))
(global-set-key (kbd "M-`") 'other-frame)

;; Change "yes or no" to "y or n"
(fset 'yes-or-no-p 'y-or-n-p)

(defun yt/reload-dot-emacs ()
  "Save the .emacs buffer if needed, then reload .emacs."
  (interactive)
  (let ((dot-emacs "~/.emacs"))
    (and (get-file-buffer dot-emacs)
         (save-buffer (get-file-buffer dot-emacs)))
    (load-file dot-emacs))
  (message "Re-initialized!"))
  
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(display-time-mode)
(require 'smart-mode-line)
(setq powerline-arrow-shape 'curve)
(setq powerline-default-separator-dir '(right . left))
(setq sml/theme 'powerline)
(setq sml/mode-width 0)
(setq sml/name-width 20)
(rich-minority-mode 1)
(setf rm-blacklist "")
(sml/setup)

(set-default-font "Source Code Pro" nil t)
(set-face-attribute 'default nil :height 100)

(when window-system
(load-theme 'zenburn t))

;; check spelling
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'org-mode-hook 'flyspell-mode)
(setq ispell-dictionary "british"
      ispell-extra-args '() ;; TeX mode "-t"
      ispell-silently-savep t)
(if (eq system-type 'darwin)
    (setq ispell-program-name "/usr/local/bin/aspell")
  (setq ispell-program-name "/usr/bin/aspell"))
(setq ispell-personal-dictionary "~/git/.emacs.d/personal/ispell-dict") ;; add personal dictionary

;; check grammar
(require 'langtool)
(setq langtool-language-tool-jar "~/java/LanguageTool-2.8/languagetool-commandline.jar")
(setq langtool-mother-tongue "en")

;; http://emacs.stackexchange.com/questions/561/how-can-i-toggle-displaying-images-in-eww-without-a-page-refresh
(defvar-local endless/display-images t)

(defun endless/toggle-image-display ()
  "Toggle images display on current buffer."
  (interactive)
  (setq endless/display-images
        (null endless/display-images))
  (endless/backup-display-property endless/display-images))

(defun endless/backup-display-property (invert &optional object)
  "Move the 'display property at POS to 'display-backup.
Only applies if display property is an image.
If INVERT is non-nil, move from 'display-backup to 'display
instead.
Optional OBJECT specifies the string or buffer. Nil means current
buffer."
  (let* ((inhibit-read-only t)
         (from (if invert 'display-backup 'display))
         (to (if invert 'display 'display-backup))
         (pos (point-min))
         left prop)
    (while (and pos (/= pos (point-max)))
      (if (get-text-property pos from object)
          (setq left pos)
        (setq left (next-single-property-change pos from object)))
      (if (or (null left) (= left (point-max)))
          (setq pos nil)
        (setq prop (get-text-property left from object))
        (setq pos (or (next-single-property-change left from object)
                      (point-max)))
        (when (eq (car prop) 'image)
          (add-text-properties left pos (list from nil to prop) object))))))
		  
