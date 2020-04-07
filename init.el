;;; package --- Summary
;;; Commentary:
;;   init.el --- Emacs configuration
;;   This is where Emacs is inited
;; --------------------------------------

;;; Code:
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
                         ("melpa" . "http://elpa.emacs-china.org/melpa/")
                         ("melpa-stable" . "http://elpa.emacs-china.org/melpa-stable/")
                         ))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

;; (require 'benchmark-init)
;; (benchmark-init/activate)
;; (add-hook 'after-init-hook 'benchmark-init/deactivate)

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
 '(TeX-auto-save t)
 '(TeX-command-extra-options "-shell-escape")
 '(TeX-engine 'xetex)
 '(TeX-parse-self t)
 '(blink-cursor-mode nil)
 '(c-basic-offset 4)
 '(cmake-tab-width 4 t)
 '(column-number-mode t)
 '(company-dabbrev-downcase nil)
 '(company-idle-delay 0.2)
 '(company-selection-wrap-around t)
 '(dired-use-ls-dired nil)
 '(electric-pair-mode t)
 '(enable-recursive-minibuffers t)
 '(indent-tabs-mode nil)
 '(ivy-use-virtual-buffers t)
 '(lsp-before-save-edits nil)
 '(lsp-enable-file-watchers nil)
 '(lsp-enable-indentation nil)
 '(lsp-enable-on-type-formatting nil)
 '(lsp-idle-delay 0.5)
 '(lsp-java-autobuild-enabled nil)
 '(lsp-java-code-generation-generate-comments t)
 '(lsp-java-completion-overwrite nil)
 '(lsp-java-format-on-type-enabled nil)
 '(lsp-java-save-action-organize-imports nil)
 '(lsp-python-ms-executable
   "~/.config/emacs/.cache/lsp/python-language-server/output/bin/Release/osx-x64/publish/Microsoft.Python.LanguageServer")
 '(lsp-signature-render-documentation nil)
 '(lsp-ui-sideline-show-hover t)
 '(menu-bar-mode nil)
 '(nxml-child-indent 4)
 '(org-agenda-files '("~/notes/tasks.org"))
 '(org-capture-templates
   '(("t" "Todo list item" entry
      (file+headline "~/notes/tasks.org" "Tasks")
      "* TODO %?
 %i
")
     ("j" "Journal entry" entry
      (file+olp+datetree "~/notes/journal.org" "Journals")
      "* %U %^{Title}
 %?")
     ("b" "Tidbit: quote, zinger, one-liner or textlet" entry
      (file+headline "~/notes/tidbits.org" "Tidbits")
      "* %^{Name} captured %U
 %^{Tidbit type|quote|zinger|one-liner|textlet}
 Possible inspiration: %a %i
 %?")
     ("n" "Notes" entry
      (file "~/notes/notes.org")
      "* %?")))
 '(package-selected-packages
   '(lsp-ui expand-region company-prescient ivy-prescient ess gnuplot-mode ivy ripgrep lsp-mode lsp-java delight auctex magit company yasnippet-snippets which-key flycheck zenburn-theme yasnippet))
 '(python-shell-interpreter "python3")
 '(read-process-output-max (* 1024 1024) t)
 '(reftex-plug-into-AUCTeX t)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(split-width-threshold 150)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(truncate-lines t)
 '(yas-snippet-dirs '("~/.config/emacs/snippets/")))

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

(setq inhibit-startup-message t)        ; hide the startup message
(fset 'yes-or-no-p 'y-or-n-p)           ; change all prompts to y or n
(setq backup-directory-alist `(("." . "~/.config/emacs/backups")))
(setq ring-bell-function 'ignore)
(setq-default fill-column 80)
(add-hook 'after-init-hook (lambda () (message "Emacs started in %s" (emacs-init-time))))
(add-to-list 'Info-directory-list "/usr/local/texlive/2019basic/texmf-dist/doc/info")
;; (setq comment-style 'indent)
;; (global-hl-line-mode t)


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


(if (display-graphic-p)
    (progn
      ;; (setq initial-frame-alist ('((fullscreen . maximized))))
      ;; (setq
      ;;  mac-command-modifier 'meta
      ;;  mac-option-modifier 'none
      ;;  )

      (setq face-font-rescale-alist `(("STkaiti" . ,(/ 16.0 13))))
      (set-face-attribute 'default nil :font "Source Code Pro-13")
      (set-fontset-font t 'han      (font-spec :family "STkaiti"))
      (set-fontset-font t 'cjk-misc (font-spec :family "STkaiti"))
      )
)

(delight '((eldoc-mode nil "eldoc")
           (emacs-lisp-mode "Elisp" :major)
           (undo-tree-mode nil "Undo-Tree")))

(recentf-mode t)
(setq initial-buffer-choice 'recentf-open-files)

(defun my/open-external-terminal-project-root ()
  "Open an external Terminal window under current directory."
  (interactive)
  (let ((default-directory (cdr (project-current))))
    (shell-command "open -a Terminal ."))
  )
(global-set-key (kbd "C-c t") 'my/open-external-terminal-project-root)

(defun toggle-window-split ()
  "Toggle window split.  Works only when there are exactly two windows open.
If the windows are vertically split, turn them into positinos horizontally
split; vice versa."
  (interactive)
  (unless (= (count-windows) 2) (error "Can only toggle a frame split in two"))
  (let* ((this-win-buffer (window-buffer))
         (next-win-buffer (window-buffer (next-window)))
         (this-win-edges (window-edges (selected-window)))
         (next-win-edges (window-edges (next-window)))
         (this-win-is-2nd (not (and (<= (car this-win-edges)
                                        (car next-win-edges))
                                    (<= (cadr this-win-edges)
                                        (cadr next-win-edges)))))
         (splitter (if (= (car this-win-edges)
                          (car next-win-edges))
                       'split-window-horizontally
                     'split-window-vertically)))
    (delete-other-windows)
    (let ((first-win (selected-window)))
      (funcall splitter)
      (if this-win-is-2nd (other-window 1))
      (set-window-buffer (selected-window) this-win-buffer)
      (set-window-buffer (next-window) next-win-buffer)
      (select-window first-win)
      (if this-win-is-2nd (other-window 1)))))
(global-set-key (kbd "C-c |") 'toggle-window-split)

(global-set-key (kbd "C-c s") 'ripgrep-regexp)
(global-set-key (kbd "C-c f r") 'recentf-open-files)
(global-set-key (kbd "C-c p f") 'project-find-file)
(global-set-key (kbd "C-c p s") 'project-search)
(global-set-key (kbd "C-c p r") 'project-find-regexp)
(global-set-key (kbd "C-c p q") 'project-query-replace-regexp)
(global-set-key (kbd "C-c `") 'fileloop-continue)
(global-set-key (kbd "C-c i") 'imenu)
(global-set-key (kbd "C-x B") 'ibuffer)
(global-set-key (kbd "C-x P") 'list-processes)
(global-set-key (kbd "C-x ;") 'comment-line)
(global-set-key (kbd "C-h F") 'describe-face)

(define-key occur-mode-map "n" 'occur-next)
(define-key occur-mode-map "p" 'occur-prev)

(defun show-bookmark-list ()
  "Show bookmark list after calling 'list-bookmars'."
  (switch-to-buffer "*Bookmark List*"))
(with-eval-after-load 'bookmark
  (advice-add #'bookmark-bmenu-list :after #'show-bookmark-list))

;; Expand region
(global-set-key (kbd "C-\\") 'er/expand-region)

;; Ivy
(ivy-mode t)
(ivy-prescient-mode t)

;; Zenburn theme
(if (display-graphic-p)
    (load-theme 'zenburn t)
  ;; (load-theme 'terminal-pro t)
  ;; (load-theme 'terminal-silver-aerogel t)
  (load-theme 'terminal-zenburn t)
  )

;; Flycheck
(add-hook 'prog-mode-hook 'flycheck-mode)
(with-eval-after-load 'flycheck
  (define-key flycheck-mode-map (kbd "C-c f p") 'flycheck-previous-error)
  (define-key flycheck-mode-map (kbd "C-c f n") 'flycheck-next-error)
  (define-key flycheck-mode-map (kbd "C-c f l") 'flycheck-list-errors)
)

 ;; Show key bindings below
(which-key-mode)
(which-key-setup-side-window-bottom)

;; Yasnippet mode
(add-hook 'prog-mode-hook 'yas-minor-mode)
(add-hook 'LaTeX-mode-hook 'yas-minor-mode)
(add-hook 'org-mode-hook 'yas-minor-mode)

;; Company mode
(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'LaTeX-mode-hook 'company-mode)
(add-hook 'org-mode-hook 'company-mode)
(add-hook 'inferior-python-mode-hook 'company-mode)
(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (with-eval-after-load 'yasnippet
    (yas-reload-all)
    (defun company-backend-with-yas (backend)
      "Add `yasnippet' to company backend."
      (if (and (listp backend) (member 'company-yasnippet backend))
          backend
        (append (if (consp backend) backend (list backend))
                '(:with company-yasnippet))))

    (defun my-company-enbale-yas (&rest _)
      "Enable `yasnippet' in `company'."
      (setq company-backends (mapcar #'company-backend-with-yas company-backends)))
    ;; Enable in current backends
    (my-company-enbale-yas)
    (with-eval-after-load 'lsp-mode
      ;; Support `company-lsp'
      (advice-add #'lsp--auto-configure :after #'my-company-enbale-yas))

    (defun my-company-yasnippet-disable-after-dot (fun command &optional arg &rest _ignore)
      "Enable yasnippet but disable it after dot."
      (if (eq command 'prefix)
          (when-let ((prefix (funcall fun 'prefix)))
            (unless (memq (char-before (- (point) (length prefix)))
                          '(?. ?> ?\( ?\) ?\[ ?{ ?} ?\" ?' ?`))
              prefix))
        (progn
          (when (and (bound-and-true-p lsp-mode)
                     arg (not (get-text-property 0 'yas-annotation-patch arg)))
            (let* ((name (get-text-property 0 'yas-annotation arg))
                   (snip (format "%s (Snippet)" name))
                   (len (length arg)))
              (put-text-property 0 len 'yas-annotation snip arg)
              (put-text-property 0 len 'yas-annotation-patch t arg)))
          (funcall fun command arg))))
    (advice-add #'company-yasnippet :around #'my-company-yasnippet-disable-after-dot))
  ;; Causes lag
  ;; (company-prescient-mode t)
  )


;; Magit
(global-set-key (kbd "C-c g") 'magit-status)

;; LaTeX
(add-hook 'LaTeX-mode-hook 'reftex-mode)
;; (add-hook 'LaTeX-mode-hook 'cdlatex-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(setq-default TeX-master nil)

;; Gnuplot mode
(add-to-list 'auto-mode-alist '("\\.gnuplot\\'" . gnuplot-mode))
(add-to-list 'auto-mode-alist '("\\.gp\\'" . gnuplot-mode))

;; ESS and R
(with-eval-after-load 'ess
  (setq ess-eval-visibly 'nowait) ; Allow asynchronous executing
  )

;; Matlab: octave-mode
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

;; Org mode
(add-hook 'org-mode-hook 'auto-fill-mode)
;; (setq org-startup-with-inline-images t) ; Display inline images by default
;; (add-hook 'org-mode-hook 'turn-on-org-cdlatex)
(defun add-pcomplete-to-capf ()
  (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))
(add-hook 'org-mode-hook #'add-pcomplete-to-capf) ; Enable org mode completion
(add-hook 'org-mode-hook (lambda ()
                           (electric-pair-local-mode -1)
                           ))
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(with-eval-after-load 'org
;;   (org-defkey org-mode-map "\C-c{" 'org-cdlatex-environment-indent)
;;   (add-to-list 'image-type-file-name-regexps '("\\.eps\\'" . imagemagick))
;;   (add-to-list 'image-file-name-extensions "eps")
;;   (setq org-image-actual-width '(400)) ; Prevent inline images being too big
;;   (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images) ; Redisplay after babel executing
  (require 'ox-md)
  (require 'ox-beamer)
  (setq org-highlight-latex-and-related '(native))
;;   (setq org-export-coding-system 'utf-8)           ; Ensure exporting with UTF-8
  (add-to-list 'org-latex-packages-alist '("" "xeCJK"))
  (add-to-list 'org-latex-packages-alist '("" "listings")) ; Use listings package to export code blocks
  (add-to-list 'org-latex-packages-alist '("" "color")) ; Use listings package to export code blocks
  (setq org-latex-listings 'listings)
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
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (C . t)
     (js . t)
     (ditaa . t)
     (dot . t)
     (org . t)
     (shell . t)
     (latex . t)
     (R . t)
     (gnuplot . t)
     ))
  ;; (setq org-preview-latex-default-process 'imagemagick)
  ;; (setq org-format-latex-options '(:foreground auto :background "Transparent" :scale 1.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
  ;;                                              ("begin" "$1" "$" "$$" "\\(" "\\[")))
  (setq org-src-window-setup 'current-window)
  (setq org-export-use-babel nil) ; Stop Org from evaluating code blocks
  (setq org-babel-python-command "python3") ; Set the command to python3 instead of python
  (setq org-confirm-babel-evaluate nil)   ; Don't prompt me to confirm everytime I want to evaluate a block
  )

;; mu4e
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu/mu4e")
(autoload 'mu4e "/usr/local/share/emacs/site-lisp/mu/mu4e/mu4e.el" "Mu4e autoload" t)
(global-set-key (kbd "C-c m") 'mu4e)
(with-eval-after-load 'mu4e
  (setq mail-user-agent 'mu4e-user-agent) ; Use mu4e as default mail agent
  (setq mu4e-maildir (expand-file-name "~/Maildir")) ; Mail folder set to ~/mail
  (setq mu4e-get-mail-command "mbsync -c ~/.mbsyncrc -a")
  (setq mu4e-update-interval 300)
  (setq mu4e-headers-auto-update t)
  (setq mu4e-compose-signature-auto-include nil)
  (setq mu4e-view-show-addresses 't)
  (setq mu4e-confirm-quit nil)
  (setq mu4e-view-show-images t)
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))
  (add-hook 'mu4e-view-mode-hook 'visual-line-mode)
  (add-hook 'mu4e-compose-mode-hook 'visual-line-mode)
  (add-hook 'mu4e-compose-mode-hook 'company-mode)
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
  (add-to-list 'mu4e-view-actions
               '("browser view" . mu4e-action-view-in-browser) t)
  ;; (add-hook 'mu4e-view-mode-hook
  ;;           (lambda()
  ;;             ;; (local-set-key (kbd "TAB") 'org-next-link)
  ;;             ;; (local-set-key (kbd "<backtab>") 'org-previous-link)
  ;;             ;; (local-set-key (kbd "<return>") 'mu4e~view-browse-url-from-binding))
  ;;           )

  (setq mu4e-sent-folder   "/liushihao-pku/Sent Items")
  (setq mu4e-drafts-folder "/liushihao-pku/Drafts")
  (setq mu4e-trash-folder  "/liushihao-pku/Trash")
  (setq mu4e-refile-folder  "/liushihao-pku/Archive")
  (setq mu4e-attachment-dir  "~/Downloads")

  ;; Send emails
  (setq message-send-mail-function 'smtpmail-send-it)
  (setq smtpmail-stream-type 'ssl)
  (setq starttls-use-gnutls t)
  ;; Personal info
  (setq user-full-name "Shihao Liu")
  (setq user-mail-address "liushihao@pku.edu.cn")
  ;; Smtpmail setup
  (setq smtpmail-smtp-server "mail.pku.edu.cn")
  (setq smtpmail-default-smtp-server "mail.pku.edu.cn")
  (setq smtpmail-smtp-service 465)
  (setq smtpmail-smtp-user "liushihao@pku.edu.cn")

  (defvar my-mu4e-account-alist
    '(("liushihao-pku"
       (smtpmail-stream-type 'ssl)
       (user-mail-address "liushihao@pku.edu.cn")
       (smtpmail-smtp-server "mail.pku.edu.cn")
       (smtpmail-default-smtp-server "mail.pku.edu.cn")
       (smtpmail-smtp-service 465)
       (smtpmail-smtp-user "Shihao Liu")
       (mu4e-sent-folder   "/liushihao-pku/Sent Items")
       (mu4e-drafts-folder "/liushihao-pku/Drafts")
       (mu4e-trash-folder  "/liushihao-pku/Trash")
       (mu4e-refile-folder  "/liushihao-pku/Archive")
       ))
    ("nm-dev"
       (smtpmail-stream-type 'ssl)
       (user-mail-address "shihao.liu@nm.dev")
       (smtpmail-smtp-server "smtp.gmail.com")
       (smtpmail-default-smtp-server "smtp.gmail.com")
       (smtpmail-smtp-service 465)
       (smtpmail-smtp-user "Shihao Liu")
       (mu4e-sent-folder   "/nm-dev/Sent Items")
       (mu4e-drafts-folder "/nm-dev/Drafts")
       (mu4e-trash-folder  "/nm-dev/Trash")
       (mu4e-refile-folder  "/nm-dev/Archive")
       ))
  
  (defun my-mu4e-set-account ()
    "Set the account for composing a message."
    (let* ((account
            (if mu4e-compose-parent-message
                (let ((maildir (mu4e-message-field mu4e-compose-parent-message :maildir)))
                  (string-match "/\\(.*?\\)/" maildir)
                  (match-string 1 maildir))
              (completing-read (format "Compose with account: (%s) "
                                       (mapconcat #'(lambda (var) (car var))
                                                  my-mu4e-account-alist "/"))
                               (mapcar #'(lambda (var) (car var)) my-mu4e-account-alist)
                               nil t nil nil (caar my-mu4e-account-alist))))
           (account-vars (cdr (assoc account my-mu4e-account-alist))))
      (if account-vars
          (mapc #'(lambda (var)
                    (set (car var) (cadr var)))
                account-vars)
        (error "No email account found"))))
  (add-hook 'mu4e-compose-pre-hook 'my-mu4e-set-account)
  )

(with-eval-after-load 'xref
  (setq xref-prompt-for-identifier '(not xref-find-definitions
                                         xref-find-definitions-other-window
                                         xref-find-definitions-other-frame
                                         xref-find-references)))


(with-eval-after-load 'lsp-mode
  (define-key lsp-mode-map (kbd "C-c l d") 'lsp-describe-thing-at-point)
  ;; (define-key lsp-mode-map (kbd "C-c l D") 'lsp-ui-peek-find-definitions)
  ;; (define-key lsp-mode-map (kbd "C-c l R") 'lsp-ui-peek-find-references)
  (define-key lsp-mode-map (kbd "C-c l t") 'lsp-find-type-definition)
  (define-key lsp-mode-map (kbd "C-c l o") 'lsp-describe-thing-at-point)
  (define-key lsp-mode-map (kbd "C-c l r") 'lsp-rename)
  (define-key lsp-mode-map (kbd "C-c l f") 'lsp-format-buffer)
  ;; (define-key lsp-mode-map (kbd "C-c l m") 'lsp-ui-imenu)
  (define-key lsp-mode-map (kbd "C-c l x") 'lsp-execute-code-action)
  (define-key lsp-mode-map (kbd "C-c l M-s") 'lsp-describe-session)
  (define-key lsp-mode-map (kbd "C-c l M-r") 'lsp-workspace-restart)
  (define-key lsp-mode-map (kbd "C-c l S") 'lsp-shutdown-workspace)
  (define-key lsp-mode-map (kbd "C-c l a") 'xref-find-apropos)

  ;; (setq lsp-clients-texlab-executable "~/.config/emacs/.cache/lsp/texlab/target/release/texlab")
  ;; (setq lsp-log-io t)
  )

;; Lsp Python
(add-to-list 'load-path "~/.config/emacs/packages/lsp-python-ms")
(add-hook 'python-mode-hook 'lsp)
(with-eval-after-load 'python
  (require 'lsp-python-ms)
  (defun my/format-buffer ()
    "Format buffer using yapf."
    (interactive)
    (let ((old-point (point)))
      (erase-buffer)
      (insert (shell-command-to-string (concat "yapf " (buffer-name))))
      (goto-char old-point)))
  (define-key python-mode-map (kbd "C-c l F") 'my/format-buffer))

;; Lsp C++
(dolist (m (list 'c-mode-hook 'c++-mode-hook 'objc-mode-hook))
  (add-hook m (lambda ()
                (lsp)
                (setq-local company-backends (delete 'company-clang company-backends))
                (setq comment-start "/* "
                      comment-end " */")))
  )
(with-eval-after-load 'cc-mode
  (defun my/cmake-project-generate-compile-commands ()
    "ccls typically indexes an entire project. In order for this
to work properly, ccls needs to be able to obtain the source file
list and their compilation command lines."
    (interactive)
    (let ((default-directory (cdr (project-current))))
      (shell-command
       (concat "\ncmake -H. -BDebug -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=YES"
               "\nln -s Debug/compile_commands.json")))
    )
  (dolist (m (list c-mode-map c++-mode-map objc-mode-map))
    (define-key m (kbd "C-c l s") 'my/cmake-project-generate-compile-commands)))

;; Cmake
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/cmake")
(autoload 'cmake-mode "/usr/local/share/emacs/site-lisp/cmake/cmake-mode.el" "Cmake mode autoload" t)
(add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-mode))
(add-to-list 'auto-mode-alist '("\\.cmake\\'" . cmake-mode))

;; Lsp java
(with-eval-after-load 'cc-mode
  (require 'lsp-java))
(add-hook 'java-mode-hook (lambda ()
                           (lsp)
                           (setq comment-start "/* "
                                 comment-end " */")))

;; (setq gc-cons-threshold (* 800 1000))

(provide 'init)
;;; init.el ends here
