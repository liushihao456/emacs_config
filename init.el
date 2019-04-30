;;; package --- Summary
;;; Commentary:
;;   init.el --- Emacs configuration
;;   This is where Emacs is inited
;; --------------------------------------

;;; Code:
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
(eval-when-compile
  (add-to-list 'load-path "~/.emacs.d/packages/use-package")
  (add-to-list 'load-path "~/.emacs.d/packages/bind-key")
  (require 'use-package))
(setq use-package-compute-statistics t)

(use-package use-package-hydra
  :load-path "~/.emacs.d/packages/use-package-hydra"
  :ensure hydra)

;; BASIC CUSTOMIZATION
;; --------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                       Variables customized by Custom                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("e39ff005e524c331b08d613109bff0b55fc21c64914c4a243faa70f330015389" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "08ef1356470a9d3bf363ffab0705d90f8a492796e9db489936de4bde6a4fdb19" "a3fa4abaf08cc169b61dea8f6df1bbe4123ec1d2afeb01c17e11fdc31fc66379" "b54826e5d9978d59f9e0a169bbd4739dd927eead3ef65f56786621b53c031a7c" "4697a2d4afca3f5ed4fdf5f715e36a6cac5c6154e105f3596b44a4874ae52c45" "fe666e5ac37c2dfcf80074e88b9252c71a22b6f5d2f566df9a7aa4f9bea55ef8" "d2e9c7e31e574bf38f4b0fb927aaff20c1e5f92f72001102758005e53d77b8c9" "7e78a1030293619094ea6ae80a7579a562068087080e01c2b8b503b27900165c" "10461a3c8ca61c52dfbbdedd974319b7f7fd720b091996481c8fb1dded6c6116" default)))
 '(electric-pair-mode t)
 '(global-hl-line-mode t)
 '(package-selected-packages
   (quote
    (linum-relative gnuplot posframe pyim-wbdict pyim shell-pop evil spacemacs-theme helm-xref company-jedi dap-mode lsp-ui lsp-mode lsp-java ob-async ob-ipython all-the-icons hydra markdown-mode projectile helm-projectile helm-lsp web-mode org-ref ess helm-bibtex auctex magit multiple-cursors company yasnippet-snippets ace-window which-key doom-modeline flycheck doom-themes ccls neotree zenburn-theme htmlize helm-ag dashboard matlab-mode auctex-latexmk cdlatex company-lsp helm-swoop undo-tree yasnippet)))
 '(python-shell-interpreter "python3")
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(truncate-lines t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                         Faces customized by Custom                        ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                            Basic customizations                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq inhibit-startup-message t) ; hide the startup message
(setq
 mac-command-modifier 'meta
 mac-option-modifier 'none
 )
;; change all prompts to y or n
(fset 'yes-or-no-p 'y-or-n-p)
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq ring-bell-function 'ignore)
(setq-default fill-column 80)

;; Kill currnet line and copy current line
(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-beginning-position 2)))))

(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (message "Copied line")
     (list (line-beginning-position) (line-beginning-position 2)))))

(setq face-font-rescale-alist `(("STkaiti" . ,(/ 16.0 13))))
(set-face-attribute 'default nil :font "Source Code Pro-13")
(set-fontset-font t 'han      (font-spec :family "STkaiti"))
(set-fontset-font t 'cjk-misc (font-spec :family "STkaiti"))

(use-package helm
  :ensure t
  :init
  (helm-mode t)
  :bind (("C-x c" . hydra-helm/body)
		 ("M-x" . helm-M-x)
		 ("C-x b" . helm-mini)
		 ("M-y" . helm-show-kill-ring)
		 ("C-x C-f" . helm-find-files)
		 ("C-x r b" . helm-filtered-bookmarks)
		 ("C-s" . helm-swoop)
		 ("C-r" . helm-swoop-back-to-last-point)
		 ;; :map helm-map
		 ;; ([tab] . helm-execute-persistent-action)
		 )
  :hydra (hydra-helm (:color blue :hint nil)
					 "

		                                                 Helm
		 ^^^^^^^^------------------------------------------------------------------------------------------------------
		 [_/_] find                        [_b_] resume                     [_s_] ag                       [_c_] colors

		 [_i_] imenu                       [_a_] apropos                    [_p_] list emacs processes     [_8_] ucs

		 [_I_] imenu all buffers           [_m_] man                        [_t_] bibtex
^^^^
"
					 ("/" helm-find)
					 ("i" helm-semantic-or-imenu)
					 ("I" helm-imenu-in-all-buffers)

					 ("b" helm-resume)
					 ("a" helm-apropos)
					 ("m" helm-man-woman)

					 ("s" helm-do-grep-ag)
					 ("p" helm-list-emacs-process)
					 ("t" helm-bibtex)

					 ("c" helm-colors)
					 ("8" helm-ucs)
					 )
  :config
  (setq helm-autoresize-mode t)
  (setq helm-mode-fuzzy-match t)
  )

(use-package helm-swoop
  :ensure t
  :commands (helm-swoop helm-swoop-back-to-last-point))

(use-package projectile
  :ensure t
  :init
  (projectile-mode t)
  :config
  (setq projectile-enable-caching t)
  (define-key projectile-mode-map (kbd "C-c C-p") nil)
  )

(use-package helm-projectile
  :ensure t
  :init
  (helm-projectile-on)
  :bind (:map projectile-mode-map
			  ("C-c p" . hydra-helm-projectile/body))
  :hydra (hydra-helm-projectile (:color blue
										:hint nil)
								"

		 ^Find^                            ^List^                          ^Grep^                          ^Compile^

		 ^^^^^^^^-----------------------------------------------------------------------------------------------------------------

		 [_f_] files                       [_e_] recent files              [_s s_] ag                      [_c_] compile project

		 [_a_] other files                 [_p_] proj                      [_s g_] grep

		 [_F_] files all prj               [_b_] buff curr proj

		 [_g_] files at point              [_h_] helm interface

		 [_d_] dir
		 "
								("f" helm-projectile-find-file)
								("a" helm-projectile-find-other-file)
								("F" helm-projectile-find-file-in-known-projects)
								("g" helm-projectile-find-file-dwim)
								("d" helm-projectile-find-dir)

								("e" helm-projectile-recentf)
								("p" helm-projectile-switch-project)
								("b" helm-projectile-switch-to-buffer)
								("h" helm-projectile)

								("s s" helm-projectile-ag)
								("s g" helm-projectile-grep)

								("c" projectile-compile-project))
  )

;; (use-package zenburn-theme
;;   :ensure t
;;   :config
;;   (load-theme 'zenburn t)
;;   )

(use-package doom-themes
  :ensure t
  :config
  ;; (load-theme 'doom-one t)
  ;; (load-theme 'doom-one-light t)
  ;; (load-theme 'doom-solarized-light t)
  (doom-themes-neotree-config)
  )

(use-package spacemacs-theme
  :ensure t
  :defer t
  :init
  (load-theme 'spacemacs-dark t)
  (setq spacemacs-theme-underline-parens t)
  )

(use-package flycheck
  :ensure t
  ;; :hook (prog-mode . flycheck-mode)
  )

;; Doom modeline
(use-package doom-modeline
  :ensure t
  :config
  (doom-modeline-mode)
  (setq doom-modeline-bar-width 3)
  (setq doom-modeline-height 10)
  )

(add-hook 'after-init-hook 'toggle-frame-fullscreen) ; start emacs in fullscreen

(use-package dashboard
  :if (< (length command-line-args) 2)
  :preface
  (defun my/dashboard-banner ()
    "Sets a dashboard banner including information on package initialization
     time and garbage collections."
    (setq dashboard-banner-logo-title
          (format "Emacs ready in %.2f seconds with %d garbage collections."
                  (float-time
                   (time-subtract after-init-time before-init-time)) gcs-done)))
  :ensure t
  :init
  (add-hook 'after-init-hook 'dashboard-refresh-buffer)
  (add-hook 'dashboard-mode-hook 'my/dashboard-banner)
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner "~/.emacs.d/packages/spacemacs-icon/spacemacs-logo.png")
  ;; (setq dashboard-banner-logo-title "Emacs and the changing world.") ; change the title
  (setq dashboard-items '((recents  . 10)
                          (projects . 10)
						  (bookmarks . 5)
						  ))
  (setq dashboard-center-content t)
  )

(setq-default bidi-display-reordering nil) ; improve long-line performance

;; Show key bindings on the right
(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  )

;; Quickly switch between windows
(use-package ace-window
  :ensure t
  :bind ("M-o" . ace-window)
  :config
  (setq aw-keys '(97 115 100 102 103 104 106 107 108))
  )

(use-package yasnippet
  :ensure t
  :ensure yasnippet-snippets
  :hook ((prog-mode LaTeX-mode org-mode) . yas-minor-mode)
  :config
  (setq yas/root-directory "~/.emacs.d/snippets/")
  (yas-load-directory yas/root-directory)
  (add-hook 'python-mode-hook (lambda ()
								(setq-local yas-indent-line 'fixed)))
  )

(use-package company
  :ensure t
  :hook ((prog-mode org-mode eshell-mode shell-mode inferior-python-mode inferior-ess-mode) . company-mode)
  :config
  (setq company-idle-delay 0)
  (setq company-selection-wrap-around t)
  )

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode)
  (setq undo-tree-visualizer-timestamps t)
  (setq undo-tree-visualizer-diff t)
  )


(use-package multiple-cursors
  :ensure t
  :bind ("C-c m" . hydra-multiple-cursors/body)
  :hydra (hydra-multiple-cursors (:hint nil)
								 "

          Previous^^                  Next^^                 Miscellaneous         % 2(mc/num-cursors) cursor%s(if (> (mc/num-cursors) 1) \"s\" \"\")
         
         ---------------------------------------------------------------------------------------------------
         
          [_p_]   Next                [_n_]   Next           [_l_] Edit lines        [_0_] Insert numbers
         
          [_P_]   Skip                [_N_]   Skip           [_a_] Mark all          [_A_] Insert letters
         
          [_M-p_] Unmark              [_M-n_] Unmark         [_s_] Search
         
          [Click] Cursor at point   [_q_]   Quit
         "
								 ("l" mc/edit-lines :exit t)
								 ("a" mc/mark-all-like-this :exit t)
								 ("n" mc/mark-next-like-this)
								 ("N" mc/skip-to-next-like-this)
								 ("M-n" mc/unmark-next-like-this)
								 ("p" mc/mark-previous-like-this)
								 ("P" mc/skip-to-previous-like-this)
								 ("M-p" mc/unmark-previous-like-this)
								 ("s" mc/mark-all-in-region-regexp :exit t)
								 ("0" mc/insert-numbers :exit t)
								 ("A" mc/insert-letters :exit t)
								 ("<mouse-1>" mc/add-cursor-on-click)
								 ;; Help with click recognition in this hydra
								 ("<down-mouse-1>" ignore)
								 ("<drag-mouse-1>" ignore)
								 ("q" nil))
  )

(defun narrow-or-widen-dwim (p)
  
  "If the buffer is narrowed, it widens.  Otherwise, it narrows intelligently.
Intelligently means: region, org-src-block, org-subtree, or defun,
whichever applies first.
Narrowing to org-src-block actually calls `org-edit-src-code'.
 
  With prefix P, don't widen, just narrow even if buffer is already
narrowed."

  (interactive "P")
  (declare (interactive-only))
  (cond ((and (buffer-narrowed-p) (not p)) (widen))
		((region-active-p)
		 (narrow-to-region (region-beginning) (region-end)))
		(t (narrow-to-defun))))
(global-set-key (kbd "C-c n") 'narrow-or-widen-dwim)

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  )

(use-package neotree
  :ensure t
  :bind ("C-x a" . neotree-toggle)
  :config
  (setq projectile-switch-project-action 'neotree-projectile-action)
  (setq neo-smart-open t)
  (setq neo-window-width 32)
  (setq neo-vc-integration (quote (face)))
  )

;; LaTeX
(use-package tex
  :defer t
  :ensure auctex
  :ensure helm-bibtex
  :init
  ;; (add-hook 'LaTeX-mode-hook 'flyspell-mode) ; Enable spell check in latex mode
  (add-hook 'LaTeX-mode-hook 'auto-fill-mode) ; Enable auto-fill in latex mode
  (add-hook 'LaTeX-mode-hook 'reftex-mode)    ; Enable reftex mode in latex mode
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (add-hook 'LaTeX-mode-hook (lambda ()
							   (setq TeX-engine 'xetex)
							   (setq TeX-command-extra-options "-shell-escape")))
  (reftex-mode t)
  (setq TeX-show-compilation t)
  (setq reftex-plug-into-AUCTeX t)
  (setq bibtex-completion-cite-prompt-for-optional-arguments nil)
  (setq bibtex-completion-bibliography ; set up helm-bibtex
		'("~/RA/mybib.bib"
		  "~/RA/newadded.bib"
		  "~/paper/pub/thesis.bib"))
  (require 'helm-bibtex)
  (helm-delete-action-from-source "Insert citation" helm-source-bibtex)
  (helm-add-action-to-source "Insert Citation" 'helm-bibtex-insert-citation helm-source-bibtex 0) ; Set the default action to insert citation
  )

(use-package cdlatex
  :ensure t
  :hook (LaTeX-mode . cdlatex-mode))

(use-package auctex-latexmk
  :ensure t
  :hook (LaTeX-mode . auctex-latexmk-setup)
  :config
  (setq TeX-command-default "LatexMk")
  )

;; Matlab mode
(use-package matlab-mode
  :ensure t
  :commands matlab-shell
  )

;; Gnuplot mode
(use-package gnuplot
  :ensure t
  :mode (("\\.gnuplot\\'" . gnuplot-mode)
		 ("\\.gp\\'" . gnuplot-mode))
  )

;; ESS and R
(use-package ess
  :ensure t
  :commands R
  :config
  (setq ess-eval-visibly 'nowait)	; Allow asynchronous executing
  )

;; Org mode
(use-package org
  :ensure t
  ;; :ensure org-ref
  :ensure ob-ipython
  :mode ("\\.org\\'" . org-mode)
  :init
  (add-hook 'org-mode-hook 'auto-fill-mode)
  ;; (setq org-startup-with-inline-images t) ; Display inline images by default
  (defun add-pcomplete-to-capf ()
    (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))
  (add-hook 'org-mode-hook #'add-pcomplete-to-capf) ; Enable org mode completion
  (add-hook 'org-mode-hook (lambda ()
							 (setq-local company-minimum-prefix-length 1)))
  (define-key global-map (kbd "C-c 2") 'org-capture) ; Org-capture
  (setq org-capture-templates
		'(("t" "Todo list item"
		   entry (file+headline "~/notes/tasks.org" "Tasks")
		   "* TODO %?\n %i\n")
		  ;; "* TODO %?\n %i\n %a")

		  ("j" "Journal entry"
		   entry (file+olp+datetree "~/notes/journal.org" "Journals")
		   "* %U %^{Title}\n %?")

		  ("b" "Tidbit: quote, zinger, one-liner or textlet"
		   entry (file+headline "~/notes/tidbits.org" "Tidbits")
		   "* %^{Name} captured %U\n %^{Tidbit type|quote|zinger|one-liner|textlet}\n Possible inspiration: %a %i\n %?")

		  ("n" "Notes"
		   entry (file "~/notes/notes.org" )
		   "* %?")
		  ))
  :config
  (setq org-startup-indented t)		; Indent the tree structure
  ;; It is slow to require org-ref
  ;; (require 'org-ref)
  ;; (setq reftex-default-bibliography '("~/RA/mybib.bib"))
  ;; (setq org-ref-default-bibliography '("~/RA/mybib.bib"))

  (add-hook 'org-mode-hook 'turn-on-org-cdlatex)
  ;; (org-defkey org-mode-map "`" 'cdlatex-math-symbol)
  ;; (org-defkey org-mode-map (kbd "C-;") 'cdlatex-math-modify)
  (org-defkey org-mode-map "\C-c{" 'org-cdlatex-environment-indent)

  ;; Continuous numbering of org mode equations
  (defun org-renumber-environment (orig-func &rest args)
    (let ((results '())
		  (counter -1)
		  (numberp))
      (setq results (loop for (begin .  env) in
						  (org-element-map (org-element-parse-buffer) 'latex-environment
										   (lambda (env)
											 (cons
											  (org-element-property :begin env)
											  (org-element-property :value env))))
						  collect
						  (cond
						   ((and (string-match "\\\\begin{equation}" env)
								 (not (string-match "\\\\tag{" env)))
							(incf counter)
							(cons begin counter))
						   ((string-match "\\\\begin{align}" env)
							(prog2
								(incf counter)
								(cons begin counter)
							  (with-temp-buffer
								(insert env)
								(goto-char (point-min))
								;; \\ is used for a new line. Each one leads to a number
								(incf counter (count-matches "\\\\$"))
								;; unless there are nonumbers.
								(goto-char (point-min))
								(decf counter (count-matches "\\nonumber")))))
						   (t
							(cons begin nil)))))

      (when (setq numberp (cdr (assoc (point) results)))
		(setf (car args)
			  (concat
			   (format "\\setcounter{equation}{%s}\n" numberp)
			   (car args)))))
    (apply orig-func args))
  (advice-add 'org-create-formula-image :around #'org-renumber-environment)
  
  (add-to-list 'image-type-file-name-regexps '("\\.eps\\'" . imagemagick))
  (add-to-list 'image-file-name-extensions "eps")
  (setq org-image-actual-width '(400)) ; Prevent inline images being too big
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images) ; Redisplay after babel executing
  (require 'ox-md)
  (require 'ox-beamer)
  (require 'ox-latex)
  (setq org-highlight-latex-and-related '(latex script entities))
  (set-face-foreground 'org-latex-and-related "orange")
  (setq org-export-coding-system 'utf-8)	       ; Ensure exporting with UTF-8
  (add-to-list 'org-latex-packages-alist '("" "listings")) ; Use listings package to export code blocks
  ;; (add-to-list 'org-latex-packages-alist '("" "xcolor")) ; xcolor prevents latex-preview to use current text font color
  (add-to-list 'org-latex-packages-alist '("" "xeCJK"))
  (setq org-latex-listings 'listings)
  ;; (add-to-list 'org-latex-packages-alist '("" "minted")) ; Use minted package to export code blocks
  ;; (setq org-latex-listings 'minted)
  (add-to-list 'org-latex-classes '("ctexart" "\\documentclass[11pt]{ctexart}
\\ctexset{section/format=\\Large\\bfseries}"
									("\\section{%s}" . "\\section*{%s}")
									("\\subsection{%s}" . "\\subsection*{%s}")
									("\\subsubsection{%s}" . "\\subsubsection*{%s}")
									("\\paragraph{%s}" . "\\paragraph*{%s}")
									("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes '("ctexrep" "\\documentclass[11pt]{ctexrep}
\\ctexset{section/format=\\Large\\bfseries}"
									("\\part{%s}" . "\\part*{%s}")
									("\\chapter{%s}" . "\\chapter*{%s}")
									("\\section{%s}" . "\\section*{%s}")
									("\\subsection{%s}" . "\\subsection*{%s}")
									("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  (add-to-list 'org-latex-classes '("ctexbook" "\\documentclass[11pt]{ctexbook}"
									("\\part{%s}" . "\\part*{%s}")
									("\\chapter{%s}" . "\\chapter*{%s}")
									("\\section{%s}" . "\\section*{%s}")
									("\\subsection{%s}" . "\\subsection*{%s}")
									("\\subsubsection{%s}" . "\\subsubsection*{%s}")))
  (setq org-latex-compiler "xelatex")
  (setq org-latex-pdf-process
		'(;; "latexmk -pdflatex=xelatex -pdf -shell-escape %f"
		  "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
		  "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
		  "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
		  ))
  (setq org-latex-caption-above '(table)) ; Set the caption in exported pdf above
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (emacs-lisp . t)
     (C . t)
     (js . t)
     (ditaa . t)
     (dot . t)
     (org . t)
     (shell . t)
     (latex . t)
     (R . t)
     (gnuplot . t)
     (ipython . t)
     ))
  (add-to-list 'org-latex-listings-langs '(ipython "Python"))
  (setq org-src-fontify-natively t)
  ;; (setq org-preview-latex-default-process 'imagemagick)
  (setq org-format-latex-options '(:foreground auto :background "Transparent" :scale 1.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
											   ("begin" "$1" "$" "$$" "\\(" "\\[")))
  (setq org-src-window-setup 'current-window)
  (setq org-export-use-babel nil) ; Stop Org from evaluating code blocks to speed up exports
  (setq org-babel-python-command "python3") ; Set the command to python3 instead of python
  (setq org-confirm-babel-evaluate nil)   ; Don't prompt me to confirm everytime I want to evaluate a block
  )

(use-package htmlize
  :ensure t
  :commands htmlize-buffer		; Enable org exporting to html
  :config (setq org-html-postamble nil)		; Don't include a footer with my contact and publishing information at the bottom of every exported HTML document
  )

;; Shell
(use-package shell-pop
  :ensure t
  :bind ("C-c 1" . shell-pop)
  :custom
  (shell-pop-shell-type '("eshell" "*eshell*" (lambda () (eshell))))
  :config
  (setq shell-pop-universal-key "\C-c1")
  (setq shell-pop-full-span t)
  (push (cons "\\*shell\\*" display-buffer--same-window-action) display-buffer-alist)
  )
;; (add-to-list 'display-buffer-alist '("^\\*shell\\*$" . (display-buffer-same-window)))
;; (defun shell-other-window ()
;;   "Open a `shell' in a new window."
;;   (interactive)
;;   (select-window (split-window-below -20))
;;   (shell)
;;   )
;; (define-key global-map (kbd "C-c 1") 'shell-other-window) ; Open shell buffer below
(setq password-cache t)			; Enable password caching
(setq password-cache-expiry 3600)	; Enable password caching for one hour

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
		 ("\\.xml\\'" . web-mode))
  :config
  (setq web-mode-engines-alist
		'(("django"    . "\\.html\\'")))
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-auto-expanding t)
  )

;; mu4e
(use-package mu4e
  :ensure mu4e-alert
  :load-path "/usr/local/Cellar/mu/1.0_1/share/emacs/site-lisp/mu/mu4e"
  :bind (("M-m" . mu4e)
		 :map mu4e-headers-mode-map
		 ("." . hydra-mu4e-headers/body)
		 )
  :config
  (mu4e-alert-enable-mode-line-display)
  
  (setq mail-user-agent 'mu4e-user-agent)	; Use mu4e as default mail agent
  (setq mu4e-maildir (expand-file-name "~/Maildir"))		; Mail folder set to ~/mail
  (setq mu4e-get-mail-command "mbsync -c ~/.mbsyncrc -a")
  (setq mu4e-update-interval 300)
  (setq mu4e-view-prefer-html t)
  (setq mu4e-headers-auto-update t)
  ;; (setq mu4e-compose-format-flowed t)

  ;; ;; To view selected message in the browser, no signin, just html mail
  (add-to-list 'mu4e-view-actions
			   '("ViewInBrowser" . mu4e-action-view-in-browser) t)
  ;; Don't save message to Sent Messages, IMAP takes care of this
  (setq mu4e-sent-messages-behavior 'delete)
  (add-hook 'mu4e-view-mode-hook #'visual-line-mode)
  ;; <tab> to navigate to links, <RET> to open them in browser
  (add-hook 'mu4e-view-mode-hook
			(lambda()
			  ;; try to emulate some of the eww key-bindings
			  (local-set-key (kbd "<RET>") 'mu4e~view-browse-url-from-binding)
			  (local-set-key (kbd "<tab>") 'shr-next-link)
			  (local-set-key (kbd "<backtab>") 'shr-previous-link)))

  ;; Dynamically setting the width of the columns so it takes up the whole width
  (add-hook 'mu4e-headers-mode-hook
			(defun my/mu4e-change-headers ()
			  (interactive)
			  (setq mu4e-headers-fields
					`((:human-date . 12)
					  (:flags . 4)
					  (:from-or-to . 25)
					  (:subject . ,(- (window-body-width) 60))
					  (:size . 7)))))

  ;; Rename files when moving
  ;; NEEDED FOR MBSYNC
  (setq mu4e-change-filenames-when-moving t)
  (setq message-kill-buffer-on-exit t)
  (setq mu4e-compose-dont-reply-to-self t)

  ;; ;; Convert org mode to HTML automatically
  ;; (require 'org-mu4e)
  ;; (setq org-mu4e-convert-to-html t)

  ;; Show full addresses in view message (instead of just names)
  ;; Toggle per name with M-RET
  (setq mu4e-view-show-addresses 't)
  ;; Don't ask when quitting
  (setq mu4e-confirm-quit nil)

  (setq mu4e-sent-folder   "/liushihao-pku/Sent Items")
  (setq mu4e-drafts-folder "/liushihao-pku/Drafts")
  (setq mu4e-trash-folder  "/liushihao-pku/Trash")
  (setq mu4e-refile-folder  "/liushihao-pku/Archive")
  (setq mu4e-attachment-dir  "~/Downloads")

  (setq mu4e-view-show-images t)
  (setq mu4e-compose-signature-auto-include nil)

  ;; Send emails
  (setq message-send-mail-function 'smtpmail-send-it
		smtpmail-stream-type 'ssl
		starttls-use-gnutls t)
  ;; Personal info
  (setq user-full-name "Shihao, Liu")
  (setq user-mail-address "liushihao@pku.edu.cn")
  ;; Smtpmail setup
  (setq smtpmail-smtp-server "mail.pku.edu.cn")
  (setq smtpmail-default-smtp-server "mail.pku.edu.cn")
  (setq smtpmail-smtp-service 465)
  (setq smtpmail-smtp-user "liushihao@pku.edu.cn")

  (defhydra hydra-mu4e-headers (:color blue :hint nil)
    "
  ^General^         ^Search^              _!_: read       _#_: deferred    ^Switches^
  
  -^^-----------------^^-----------------  _?_: unread     _%_: pattern    -^^------------------
  
  _n_: next          _s_: search           _r_: refile     _&_: custom      _O_: sorting
  
  _p_: prev          _S_: edit prev qry    _u_: unmk       _+_: flag        _P_: threading
  
  _]_: n unred       _/_: narrow search    _U_: unmk *     _-_: unflag      _Q_: full-search
  
  _[_: p unred       _b_: search bkmk      _d_: trash      _T_: thr         _V_: skip dups
	   
	   _y_: sw view       _B_: edit bkmk        _D_: delete     _t_: subthr      _W_: include-related
	   
	   _R_: reply         _{_: previous qry     _m_: move      -^^----------------^^------------------
	   
	   _C_: compose       _}_: next query       _a_: action     _|_: thru shl    _`_: update, reindex
	   
	   _F_: forward       _C-+_: show more      _A_: mk4actn    _H_: help        _;_: context-switch
	   
	   --------------   _C--_: show less      _*_: *thing     _q_: quit hdrs   _j_: jump2maildir
	   "

    ;; general
    ("n" mu4e-headers-next)
    ("p" mu4e-headers-previous)
    ("[" mu4e-select-next-unread)
    ("]" mu4e-select-previous-unread)
    ("y" mu4e-select-other-view)
    ("R" mu4e-compose-reply)
    ("C" mu4e-compose-new)
    ("F" mu4e-compose-forward)
    ;; ("o" my/org-capture-mu4e)                  ; differs from built-in

    ;; search
    ("s" mu4e-headers-search)
    ("S" mu4e-headers-search-edit)
    ("/" mu4e-headers-search-narrow)
    ("b" mu4e-headers-search-bookmark)
    ("B" mu4e-headers-search-bookmark-edit)
    ("{" mu4e-headers-query-prev)              ; differs from built-in
    ("}" mu4e-headers-query-next)              ; differs from built-in
    ("C-+" mu4e-headers-split-view-grow)
    ("C--" mu4e-headers-split-view-shrink)

    ;; mark stuff
    ("!" mu4e-headers-mark-for-read)
    ("?" mu4e-headers-mark-for-unread)
    ("r" mu4e-headers-mark-for-refile)
    ("u" mu4e-headers-mark-for-unmark)
    ("U" mu4e-mark-unmark-all)
    ("d" mu4e-headers-mark-for-trash)
    ("D" mu4e-headers-mark-for-delete)
    ("m" mu4e-headers-mark-for-move)
    ("a" mu4e-headers-action)                  ; not really a mark per-se
    ("A" mu4e-headers-mark-for-action)         ; differs from built-in
    ("*" mu4e-headers-mark-for-something)

    ("#" mu4e-mark-resolve-deferred-marks)
    ("%" mu4e-headers-mark-pattern)
    ("&" mu4e-headers-mark-custom)
    ("+" mu4e-headers-mark-for-flag)
    ("-" mu4e-headers-mark-for-unflag)
    ("t" mu4e-headers-mark-subthread)
    ("T" mu4e-headers-mark-thread)

    ;; miscellany
    ("q" mu4e~headers-quit-buffer)
    ("H" mu4e-display-manual)
    ("|" mu4e-view-pipe)                       ; does not seem built-in any longer

    ;; switches
    ("O" mu4e-headers-change-sorting)
    ("P" mu4e-headers-toggle-threading)
    ("Q" mu4e-headers-toggle-full-search)
    ("V" mu4e-headers-toggle-skip-duplicates)
    ("W" mu4e-headers-toggle-include-related)

    ;; more miscellany
    ("`" mu4e-update-mail-and-index)           ; differs from built-in
    (";" mu4e-context-switch)
    ("j" mu4e~headers-jump-to-maildir)

    ("." nil))
  )

(use-package helm-xref
  :ensure t
  :config
  (setq xref-show-xrefs-function 'helm-xref-show-xrefs)
  (setq xref-prompt-for-identifier '(not xref-find-definitions
										 xref-find-definitions-other-window
										 xref-find-definitions-other-frame
										 xref-find-references))
  )

(setq-default c-basic-offset 4)
(setq-default tab-width 4)

;; lsp mode
(use-package lsp-mode
  :ensure t
  :ensure helm-lsp
  :ensure company-jedi
  :commands lsp
  :hook (python-mode . (lambda ()
						 (lsp)
						 (setq-local company-backends '(company-jedi company-files))
						 ))
  :config
  ;; (setq lsp-print-io t)
  ;; (setq lsp-print-performance t)

  (setq lsp-prefer-flymake nil)
  (defhydra hydra-lsp (:exit t :hint nil)
    "
          Buffer^^               Peek^^                 Symbol^^              Server^^                  Search
         ----------------------------------------------------------------------------------------------------------
          [_f_] format           [_d_] declaration      [_o_] documentation   [_M-r_] restart           [_1_] helm-lsp wkspc symbol
         
          [_m_] imenu            [_D_] definition       [_r_] rename          [_S_]   shutdown          [_2_] all active wkspc symbol
         
          [_x_] execute action   [_R_] references       [_t_] type defn       [_M-s_] describe session  [_a_] xref-find-apropos
         
         ^^                      [_i_] implementation
         
"
    ("d" lsp-find-declaration)
    ("D" lsp-ui-peek-find-definitions)
    ("R" lsp-ui-peek-find-references)
    ("i" lsp-ui-peek-find-implementation)
    ("t" lsp-find-type-definition)
    ;; ("s" lsp-signature-help)
    ("o" lsp-describe-thing-at-point)
    ("r" lsp-rename)

    ("f" lsp-format-buffer)
    ("m" lsp-ui-imenu)
    ("x" lsp-execute-code-action)

    ("M-s" lsp-describe-session)
    ("M-r" lsp-restart-workspace)
    ("S" lsp-shutdown-workspace)

    ("1" helm-lsp-workspace-symbol)
    ("2" helm-lsp-global-workspace-symbol)
    ("a" xref-find-apropos)
    )
  (global-set-key (kbd "C-x l") 'hydra-lsp/body)
  )

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  )
(use-package company-lsp
  :ensure t
  :commands company-lsp)

;; Lsp c++
(use-package ccls
  :ensure t
  :defer t
  :hook ((c-mode c++-mode objc-mode) .
         (lambda ()
		   (require 'ccls)
		   (require 'lsp)
		   (lsp)
		   (setq-local company-backends '(company-lsp))
		   ))
  :custom
  (ccls-executable "~/.emacs.d/ccls")
  )

;; Lsp java
(use-package lsp-java
  :ensure t
  :defer t
  :hook (java-mode . (lambda ()
					   (require 'lsp-java)
					   (require 'lsp)
					   (lsp)
					   (setq-local company-backends '(company-lsp))
					   ))
  :config
  (setq lsp-java-save-action-organize-imports nil)
  (setq lsp-java-format-on-type-enabled nil)
  )

;; gud
(use-package gud
  :commands gud-gdb
  :config
  (defhydra hydra-gud (:hint nil
							 :foreign-keys run)
    "
          Breakpoint^^               Run^^                 Repl^^              Stack^^          Instruction mode^^
         ----------------------------------------------------------------------------------------------------------
          [_b_] break                [_r_] run             [_p_] print         [_<_] up         [_M-s_] stepi
         
          [_d_] remove               [_s_] step                              [_>_] down       [_M-n_] nexti
         
          [_l_] list breaks          [_n_] next                              [_1_] stack current thread
         
          [_q_] quit                 [_c_] continue                          [_2_] stack all threads
         
                                   [_f_] finish
"
    ("b" gud-break)
    ("d" gud-remove)
    ("l" gud-listb)

    ("r" gud-run)
    ("s" gud-step)
    ("n" gud-next)
    ("c" gud-cont)

    ("p" gud-print)
    ("f" gud-finish)

    ("<" gud-up)
    (">" gud-down)
    ("1" gud-bt)
    ("2" gud-bt-all)

    ("M-s" gud-stepi)
    ("M-n" gud-nexti)

    ("q" nil)
    )
  (global-set-key (kbd "C-c g") 'hydra-gud/body)
  )

(use-package gud-lldb
  :load-path "~/.emacs.d/packages/gud-lldb"
  :commands (lldb)
  )

(use-package dap-mode
  :ensure t
  :defer t
  :hook ((java-mode . (lambda ()
						(dap-mode t)
						(dap-ui-mode t)
						(require 'dap-java)
						))
		 ;; (python-mode . (lambda ()
		 ;; 				  (dap-mode t)
		 ;; 				  (dap-ui-mode t)
		 ;; 				  (require 'dap-python)
		 ;; 				  ))
		 )
  :init
  (defun my/window-visible (b-name)
    "Return whether B-NAME is visible."
    (-> (-compose 'buffer-name 'window-buffer)
		(-map (window-list))
		(-contains? b-name)))

  (defun my/show-debug-windows (session)
    "Show debug windows."
    (let ((lsp--cur-workspace (dap--debug-session-workspace session)))
      (save-excursion
		;; display locals
		(unless (my/window-visible dap-ui--locals-buffer)
          (dap-ui-locals))
		;; display sessions
		(unless (my/window-visible dap-ui--sessions-buffer)
          (dap-ui-sessions))
		(unless (my/window-visible "*dap-ui-repl*")
          (dap-ui-repl))
		(unless (my/window-visible "*Breakpoints*")
          (dap-ui-breakpoints))
		)))
  (add-hook 'dap-stopped-hook 'my/show-debug-windows)
  (defun my/hide-debug-windows (session)
    "Hide debug windows when all debug sessions are dead."
    (unless (-filter 'dap--session-running (dap--get-sessions))
      (and (get-buffer dap-ui--sessions-buffer)
           (kill-buffer dap-ui--sessions-buffer))
      (and (get-buffer dap-ui--locals-buffer)
           (kill-buffer dap-ui--locals-buffer))
      (and (get-buffer "*Breakpoints*")
           (kill-buffer "*Breakpoints*"))
      (and (get-buffer "*dap-ui-repl*")
           (kill-buffer "*dap-ui-repl*"))
      (delete-other-windows)
      ))
  (add-hook 'dap-terminated-hook 'my/hide-debug-windows)

  :config
  (global-set-key (kbd "C-c 3") 'dap-debug)
  (global-set-key (kbd "C-c 4") 'dap-hydra)
  )

;; Chinese input method
(use-package pyim
  :ensure t
  :ensure pyim-wbdict
  :ensure posframe
  :demand t
  :config
  (require 'pyim-wbdict)
  (pyim-wbdict-v98-enable)
  (setq default-input-method "pyim")
  (setq pyim-default-scheme 'wubi)
  (require 'posframe)
  (setq pyim-page-tooltip 'posframe)
  (setq pyim-posframe-border-width 5)
  (setq pyim-page-length 5)
  )

;; (use-package evil
;;   :ensure t
;;   :config
;;   (require 'evil)
;;   (evil-mode 1)
;;   (setq evil-insert-state-cursor nil)
;;   (setq evil-replace-state-cursor nil)
;;   (setq evil-operator-state-cursor nil)
;;   (setq evil-default-state 'emacs)
;;   )

(provide 'init)
;;; init.el ends here
