;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Identity
(setq user-full-name "Louis Pearson"
      user-mail-address "lep@fastmail.com")

;; Visual configuration
(setq doom-theme 'doom-dracula)
(setq doom-font
      (font-spec :name "Source Code Pro"
                 :family "monospace"
                 :size 14))
(setq doom-variable-pitch-font
      (font-spec :name "Overpass" :family "sans" :size 14))

;; nil -> no line numbers, t -> absolute, or 'relative
(setq display-line-numbers-type 'relative)

;; Org configuration
(setq org-directory "~/Documents/org/")
(setq org-journal-file-type 'weekly)
;; (add-to-list 'org-capture-templates
;;              ("w" "Web site" entry
;;               (file "")
;;               "* %a :website:\n\n%U %?\n\n%:initial"))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Automatically starts sqlup-mode when sql-mode starts.
(use-package! sqlup-mode
  :hook (sql-mode sql-interactive-mode))

;; Tell projectile the default search path for projects
(setq projectile-project-search-path '("~/repos/"))

;; elfeed configuration
(after! elfeed
  (setq elfeed-search-filter "@1-month-ago +unread")
  (add-hook! 'elfeed-search-mode-hook 'elfeed-update)
  (setq rmh-elfeed-org-files (list "~/Documents/Desttinghim Sync/org/elfeed.org")))

;; email setup
(setq mu4e-alert-interesting-mail-query
      (concat
         "flag:unread"
         " AND NOT flag:trashed"
         " AND NOT maildir:"
         "/fastmail/Archive"))
(after! mu4e
  (setq mu4e-get-mail-command "mbsync -c ~/.config/isync/mbsyncrc -a"
        mu4e-update-interval 300
        sendmail-program (executable-find "msmtp")
        send-mail-function #'smtpmail-send-it
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail
        mu4e-context-policy 'ask-if-none
        mu4e-compose-context-polcy 'always-ask
        mu4e-bookmarks
       '(( :name  "Unread messages"
           :query "flag:unread AND NOT flag:trashed AND NOT maildir:/fastmail/Archive"
           :key ?u)
         ( :name "Today's messages"
           :query "date:today..now"
           :key ?t)
         ( :name "Last 7 days"
           :query "date:7d..now"
           :hide-unread t
           :key ?w)
         ( :name "Messages with images"
           :query "mime:image/*"
           :key ?p))))

;; Each path is relative to the path of the maildir you passed to mu
(set-email-account! "fastmail"
  '((mu4e-sent-folder       . "/fastmail/Sent")
    (mu4e-drafts-folder     . "/fastmail/Drafts")
    (mu4e-trash-folder      . "/fastmail/Trash")
    (mu4e-refile-folder     . "/fastmail/All Mail")
    (smtpmail-smtp-user     . "lep@fastmail.com"))
  t)

(set-email-account! "louispearson.work"
  '((mu4e-sent-folder       . "/fastmail/Sent")
    (mu4e-drafts-folder     . "/fastmail/Drafts")
    (mu4e-trash-folder      . "/fastmail/Trash")
    (mu4e-refile-folder     . "/fastmail/All Mail")
    (smtpmail-smtp-user     . "contact@louispearson.work"))
  t)

(after! org-msg
  (setq org-msg-options "html-postamble:nil toc:nil H:5 num:nil ^:{} "
        org-msg-startup "hidestars indent inlineimages"
        org-msg-greeting-fmt "\n%s, \n\n"
        org-msg-signature "#+begin_signature\n-- Louis Pearson\n#+end_signature"))

(doom-load-envvars-file "~/.config/emacs/.local/env")

;; (use-package! 'generic-x
;;   (define-generic-mode
;;       'dialogc-mode                     ;; name of the mode to create
;;     '("%%")                             ;; comments start with %%
;;     nil                                 ;; some keywords
;;     '(("#\\w+?\\b" . 'font-lock-constant-face)
;;       ("$\\w*?\\b" . 'font-lock-variable-name-face)
;;       ("~" . 'font-lock-negation-char-face)
;;       ("(\\(?:\\(?:[$#]\\w+\\)\\|\\([[:alnum:]-+_]+\\)\\|\\(\\*\\)\\|\\(?: \\)\\)+)"
;;        (1 'font-lock-function-name-face)
;;        (2 'font-lock-preprocessor-face))
;;       )
;;     '("\\.dg$")                         ;; files for which to activate this mode
;;     nil                                 ;; other functions to call
;;     "Major mode for editing dialogc story files"    ;; doc string for mode
;;     ))

(load! "dialog.el")

(setq org-latex-compiler "lualatex")
(setq org-preview-latex-default-process 'dvisvgm)
