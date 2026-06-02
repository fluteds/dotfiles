;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "autumn"
      user-mail-address "alice.penny@outlook.com")

(add-to-list 'custom-theme-load-path (expand-file-name "themes/" doom-user-dir))
(setq doom-theme 'doom-rose-pine)
(setq display-line-numbers-type t)
(setq org-directory "~/org/")

;; dashboard -----------------------------------------------------------

(add-to-list '+dashboard-menu-sections
             '("Open notes"
               :icon (nerd-icons-octicon "nf-oct-book" :face '+dashboard-menu-title)
               :key "n"
               :action obsidian-jump)
             t)

;; editor ---------------------------------------------------------------

(after! eldoc
  (setq eldoc-idle-delay 0.1
        eldoc-echo-area-prefer-doc-buffer t))

(after! flycheck
  (setq flycheck-display-errors-delay 0.1
        flycheck-check-syntax-automatically '(save mode-enabled)))

;; ui -------------------------------------------------------------------

(after! vterm
  (setq vterm-keymap-exceptions nil)
  (add-hook 'vterm-exit-functions
            (lambda (n e) (ignore e) (when n (kill-buffer))))
  (define-key vterm-mode-map [return] #'vterm-send-return)
  (evil-define-key 'insert vterm-mode-map
    (kbd "<escape>") #'vterm--self-insert
    (kbd "C-a")   #'vterm--self-insert
    (kbd "C-b")   #'vterm--self-insert
    (kbd "C-c")   #'vterm--self-insert
    (kbd "C-d")   #'vterm--self-insert
    (kbd "C-e")   #'vterm--self-insert
    (kbd "C-f")   #'vterm--self-insert
    (kbd "C-g")   #'vterm--self-insert
    (kbd "C-j")   #'vterm--self-insert
    (kbd "C-k")   #'vterm--self-insert
    (kbd "C-m")   #'vterm--self-insert
    (kbd "C-n")   #'vterm--self-insert
    (kbd "C-p")   #'vterm--self-insert
    (kbd "C-r")   #'vterm--self-insert
    (kbd "C-SPC") #'vterm--self-insert
    (kbd "C-t")   #'vterm--self-insert
    (kbd "C-u")   #'vterm--self-insert
    (kbd "C-v")   #'vterm--self-insert
    (kbd "C-w")   #'vterm--self-insert)
  (evil-define-key 'normal vterm-mode-map
    (kbd "p")       #'vterm-yank
    (kbd "u")       #'vterm-undo
    (kbd "<return>") #'evil-resume))

(after! org
  (setq org-todo-keywords '((sequence "TODO" "STUCK" "|" "DONE" "DROPPED"))
        org-src-preserve-indentation t
        org-src-window-setup 'current-window
        org-confirm-babel-evaluate nil
        org-image-actual-width nil
        org-list-allow-alphabetical t
        org-log-done 'time)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
     (shell . t)))
  (evil-define-key 'normal org-mode-map
    (kbd "M-H") #'org-metaleft
    (kbd "M-J") #'org-metadown
    (kbd "M-K") #'org-metaup
    (kbd "M-L") #'org-metaright
    (kbd "RET") #'org-open-at-point))

;; obsidian -------------------------------------------------------------

(use-package! obsidian
  :config
  (setq obsidian-directory (expand-file-name "~/Documents/Notes")
        obsidian-inbox-directory "00. Inbox"
        obsidian-daily-notes-directory "02. Daily"
        obsidian-daily-notes-date-format "%d-%m-%y")
  (global-obsidian-mode t)
  (map! :leader
        (:prefix ("o" . "open")
         :desc "Jump to note"  "n" #'obsidian-jump
         :desc "Daily note"    "D" #'obsidian-daily-note
         :desc "New note"      "N" #'obsidian-capture
         :desc "Search notes"  "S" #'obsidian-search))
  (map! :map obsidian-mode-map
        :n "gf" #'obsidian-follow-link-at-point
        :n "gb" #'obsidian-find-backlinks))

;; browser -------------------------------------------------------------

(setq browse-url-browser-function #'browse-url-default-macosx-browser)

(defun my/search-ddg (&optional query)
  (interactive)
  (browse-url (concat "https://duckduckgo.com/?q="
                      (url-encode-url (or query (read-string "Search: "))))))

(defun my/search-wikipedia (&optional query)
  (interactive)
  (browse-url (concat "https://en.wikipedia.org/w/index.php?search="
                      (url-encode-url (or query (read-string "Wikipedia: "))))))

(defun my/search-github (&optional query)
  (interactive)
  (browse-url (concat "https://github.com/search?q="
                      (url-encode-url (or query (read-string "GitHub: "))))))

(defvar my/bookmarks
  '(("YouTube"        . "https://youtube.com")
    ("GitHub"         . "https://github.com")
    ("Hacker News"    . "https://news.ycombinator.com")
    ("NixOS packages" . "https://search.nixos.org/packages")))

(defun my/visit-bookmark ()
  (interactive)
  (let* ((choice (completing-read "Bookmark: " (mapcar #'car my/bookmarks)))
         (url (cdr (assoc choice my/bookmarks))))
    (browse-url url)))

(map! :leader
      (:prefix "s"
       :desc "DuckDuckGo" "d" #'my/search-ddg
       :desc "Wikipedia"  "W" #'my/search-wikipedia
       :desc "GitHub"     "G" #'my/search-github
       :desc "Bookmarks"  "B" #'my/visit-bookmark))

;; media ----------------------------------------------------------------

(after! dired
  (setq dired-listing-switches "-lvah"
        dired-dwim-target t)
  (defun my/dired-find-file ()
    "Enter directories in-place; open files normally."
    (interactive)
    (if (file-directory-p (dired-get-file-for-visit))
        (dired-find-alternate-file)
      (dired-find-file)))
  (defun my/dired-up ()
    (interactive)
    (let ((buf (current-buffer)))
      (dired-up-directory)
      (kill-buffer buf)))
  (evil-define-key 'normal dired-mode-map
    (kbd "RET") #'my/dired-find-file
    (kbd "u")   #'my/dired-up
    (kbd "o")   #'dired-create-directory
    (kbd "x")   #'dired-do-delete
    (kbd "d")   #'dired-do-rename
    (kbd "y")   #'dired-do-copy
    (kbd "R")   #'revert-buffer))

(after! info
  (evil-define-key 'motion Info-mode-map
    (kbd "H") #'Info-prev
    (kbd "L") #'Info-next)
  (set-face-attribute 'Info-quoted nil :inherit nil))

(after! pdf-view
  (evil-define-key 'motion pdf-view-mode-map
    "h" #'scroll-right
    "l" #'scroll-left
    "j" #'pdf-view-next-line-or-next-page
    "k" #'pdf-view-previous-line-or-previous-page
    "J" #'pdf-view-scroll-up-or-next-page
    "K" #'pdf-view-scroll-down-or-previous-page
    "]" #'pdf-view-next-page-command
    "[" #'pdf-view-previous-page-command
    "-" #'pdf-view-shrink
    "+" #'pdf-view-enlarge
    "gg" #'pdf-view-first-page
    "G"  #'pdf-view-last-page
    "d"  #'pdf-view-kill-ring-save
    "y"  #'pdf-view-kill-ring-save))

(defvar my/video-extensions '("mkv" "mp4" "webm" "mp3" "wav" "m4a" "ogg"))

(defun my/open-with-mpv (path)
  (start-process (concat "mpv:" path) nil "mpv" (expand-file-name path)))

(defun my/find-file-media-advice (f &rest args)
  (if (member (file-name-extension (car args)) my/video-extensions)
      (progn (my/open-with-mpv (car args)) nil)
    (apply f args)))
(advice-add 'find-file :around #'my/find-file-media-advice)
