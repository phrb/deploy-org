(require 'package)

(if (and (= emacs-major-version 26)
         (<= emacs-minor-version 1))
    (progn (message "Fixing GNU TLS algorithm")
           (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")))


(setq package-archives '(("org" . "https://orgmode.org/elpa/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless (file-directory-p "~/.emacs.d/lisp/")
  (make-directory "~/.emacs.d/lisp"))

(unless (file-directory-p "~/.emacs.d/lisp/org-mode")
    (message "Cloning and compiling org-mode")
    (shell-command (concat "cd ~/.emacs.d/lisp && "
                           "git clone "
                           "--branch release_9.4.5 "
                           "https://code.orgmode.org/bzg/org-mode.git && "
                           "cd org-mode && make all"))
    (message "Done"))

(let ((default-directory  "~/.emacs.d/lisp/"))
  (setq load-path
        (append
         (let ((load-path (copy-sequence load-path)))
           (normal-top-level-add-to-load-path '("org-mode/lisp"
                                                "org-mode/contrib/lisp")))
         load-path)))

(unless package-archive-contents
  (package-refresh-contents))

(unless (file-directory-p "~/.emacs.d/lisp/ob-julia")
    (shell-command (concat "cd ~/.emacs.d/lisp && "
                           "git clone "
                           "--branch v0.0.1 "
                           "https://github.com/phrb/ob-julia.git && "
                           "cd ob-julia && make all")))

(if (file-directory-p "~/.emacs.d/lisp/ob-julia")
    (let ((default-directory  "~/.emacs.d/lisp/"))
      (setq load-path
            (append
             (let ((load-path (copy-sequence load-path)))
               (normal-top-level-add-to-load-path '("ob-julia")))
             load-path))))

(setq pkg-deps '(ebib
                 magit
                 ess
                 counsel
                 swiper
                 ivy
                 which-key
                 base16-theme))

(dolist (pkg pkg-deps)
  (unless (package-installed-p pkg)
    (package-install pkg)))

(savehist-mode 1)
(desktop-save-mode 1)

(setq-default desktop-save t)
(setq-default desktop-auto-save-timeout 10)

(setq-default buffer-file-coding-system 'utf-8-unix)

(setq-default indent-tabs-mode nil)

(save-place-mode 1)
(setq save-place-forget-unreadable-files nil)

(global-auto-revert-mode t)

(defvar backup-directory (concat user-emacs-directory "backups/"))
(defvar autosave-directory (concat user-emacs-directory "autosave/"))

(if (not (file-exists-p backup-directory)) (make-directory backup-directory t))
(if (not (file-exists-p autosave-directory)) (make-directory autosave-directory t))

(setq backup-directory-alist `((".*" . ,backup-directory)))
(setq auto-save-file-name-transforms `((".*" ,autosave-directory t)))

(setq make-backup-files t)
(setq auto-save-default t)
(setq auto-save-timeout 45)

(setq create-lockfiles nil)

(setq auto-save-interval 300)

(setq custom-file "~/.emacs.d/emacs-custom.el")

(if (file-exists-p custom-file)
    (load custom-file))

(setq-default fill-column 80)

(add-hook 'prog-mode-hook #'hs-minor-mode)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq inhibit-splash-screen t)

(setq split-height-threshold 20)
(setq split-width-threshold 60)

(require 'base16-theme)
(load-theme 'base16-default-dark t)

(menu-bar-mode)
(toggle-scroll-bar -1)
(tool-bar-mode)
(set-fringe-mode 0)

(add-to-list 'default-frame-alist '(font . "Liberation Mono-13" ))
(set-face-attribute 'default t :font "Liberation Mono-13" )

(blink-cursor-mode 0)

(setq scroll-step 1)
(setq scroll-conservatively  10000)
(setq auto-window-vscroll nil)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(show-paren-mode 1)

(setq-default c-default-style "linux"
              c-basic-offset 4)

(add-hook 'prog-mode-hook 'linum-mode)

(require 'which-key)
(which-key-mode)

(require 'org)

(setq org-link-file-path-type 'relative)

(add-hook 'org-mode-hook 'org-display-inline-images)
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(setq org-startup-with-inline-images nil)
;; (setq org-image-actual-width nil)

;; (setq org-hide-emphasis-markers t)
(setq org-hide-emphasis-markers nil)

(setq org-descriptive-links nil)

;; (setq org-pretty-entities t)
(setq org-pretty-entities nil)

(setq org-html-htmlize-output-type (quote css))

(setq org-cycle-separator-lines 0)

(setq org-latex-with-hyperref nil)

(require 'ox-latex)
(setq org-latex-pdf-process (list "latexmk -pdflatex='pdflatex -interaction nonstopmode -output-directory %o %f' -pdf -f %f -output-directory=%o"))

(setq org-latex-default-packages-alist nil)
(setq org-latex-packages-alist (quote (("" "booktabs" t))))
(setq org-latex-listings t)

(setq org-latex-prefer-user-labels t)

(setq org-latex-listings 'minted)

(require 'ox-md)

(require 'ox-odt)

(setq org-edit-src-auto-save-idle-delay 5)
(setq org-edit-src-content-indentation 0)
(setq org-src-fontify-natively t)
(setq org-src-window-setup (quote other-window))
(setq org-confirm-babel-evaluate nil)

(require 'org-tempo)

(setq org-babel-default-header-args
      '((:session . "none")
        (:results . "output replace")
        (:exports . "results")
        (:cache . "no")
        (:noweb . "yes")
        (:hlines . "no")
        (:tangle . "no")
        (:eval . "no-export")
        (:padnewline . "yes")))

(setq org-babel-default-header-args:R
      '((:session . "*R*")))

(setq org-babel-default-header-args:bash
      '((:session . "*Shell*")))

(setq org-babel-default-header-args:python
      '((:session . "*Python*")))

(add-to-list 'org-structure-template-alist
             '("I" . "SRC emacs-lisp :tangle init.el"))
(add-to-list 'org-structure-template-alist
             '("S" . "SRC shell :results output :session *Shell* :eval no-export :exports results"))
(add-to-list 'org-structure-template-alist
             '("j" . "SRC julia :eval no-export :exports results"))
(add-to-list 'org-structure-template-alist
             '("p" . "SRC python :results output :session *Python* :eval no-export :exports results"))
(add-to-list 'org-structure-template-alist
             '("r" . "SRC R :results output :session *R* :eval no-export :exports results"))
(add-to-list 'org-structure-template-alist
             '("g" . "SRC R :results graphics output :session *R* :file \".pdf\" :width 10 :height 10 :eval no-export"))
(add-to-list 'org-structure-template-alist
             '("t" . "SRC latex :results latex :exports results :eval no-export"))

(setq python-shell-completion-native-enable nil)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (R . t)
   (C . t)
   (python . t)
   (julia . t)
   (emacs-lisp . t)
   (shell . t)
   (ruby . t)
   (org . t)
   (makefile . t)
   (latex . t)
   ))

(require 'org-attach)
(setq org-link-abbrev-alist '(("att" . org-attach-expand-link)))

(require 'ox-extra)
(ox-extras-activate '(ignore-headlines))

(setq ess-indent-level 4)

(require 'ivy)
(ivy-mode 1)

(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")

(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)

(require 'magit)
(define-key global-map (kbd "C-c g") 'magit-status)
