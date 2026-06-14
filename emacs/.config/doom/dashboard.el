;;; dashboard.el --- Bobamacs custom dashboard -*- lexical-binding: t; -*-

;; Place a boba tea PNG at ~/.config/doom/boba.png to display the image.
;; Recommended: ~300px wide, transparent background PNG.

(defvar my/boba-banner-image
  (expand-file-name "boba.png" doom-user-dir)
  "Path to the boba tea banner image.")

(defvar my/boba-quote
  "\" Keep your hands on the home row, and let Evil do the rest. \""
  "Quote shown on the dashboard.")

(defvar my/boba-org-files
  '("habits" "notes" "projects" "todo")
  "Org files listed in the GET THINGS DONE column.")

(defun my/boba--center (str)
  "Return STR padded so it appears centered in the current window."
  (let* ((w   (window-width))
         (len (string-width str))
         (pad (max 0 (/ (- w len) 2))))
    (concat (make-string pad ?\s) str)))

(defun my/boba--ic (str)
  "Insert STR centered, followed by a newline."
  (insert (my/boba--center str) "\n"))

;;; ─── Widgets ─────────────────────────────────────────────────────────────────

(defun my/boba-widget-image ()
  "Display boba.png if it exists and Emacs is running in GUI mode."
  (when (and (display-graphic-p) (file-exists-p my/boba-banner-image))
    (let* ((img (create-image my/boba-banner-image nil nil :scale 0.35))
           (iw  (car (image-size img t)))
           (cw  (frame-char-width))
           (pad (max 0 (/ (- (window-width) (ceiling (/ (float iw) cw))) 2))))
      (insert "\n" (make-string pad ?\s))
      (insert-image img)
      (insert "\n\n"))))

(defun my/boba-widget-welcome ()
  "Display the centered welcome box with package count and load time."
  (let* ((title    "Welcome to Bobamacs 30.2")
         (subtitle (condition-case _
                       (format "%d packages loaded in %.6f seconds"
                               (length doom-packages)
                               (float-time (time-subtract (current-time) before-init-time)))
                     (error "Doom Emacs")))
         (inner    62))
    (cl-flet ((cbox (s)
                (let* ((l  (string-width s))
                       (lp (max 0 (/ (- inner l) 2)))
                       (rp (max 0 (- inner l lp))))
                  (concat "│" (make-string lp ?\s) s (make-string rp ?\s) "│"))))
      (my/boba--ic (concat "┌" (make-string inner ?─) "┐"))
      (my/boba--ic (cbox title))
      (my/boba--ic (cbox subtitle))
      (my/boba--ic (concat "└" (make-string inner ?─) "┘")))
    (insert "\n")))

(defun my/boba-widget-quote ()
  "Display the centered quote."
  (my/boba--ic my/boba-quote)
  (insert "\n"))

(defun my/boba-widget-columns ()
  "Display Quick Actions and GET THINGS DONE side by side."
  (let* ((col    27)
         (gap     4)
         (gs     (make-string gap ?\s))
         (total  (+ (* 2 col) gap))
         (margin (make-string (max 0 (/ (- (window-width) total) 2)) ?\s))
         (acts   '(("[f]" "Find File")
                   ("[p]" "Switch Project")
                   ("[e]" "Toggle Explorer")
                   ("[t]" "Toggle Theme")
                   ("[q]" "Quit Emacs"))))
    (cl-flet ((top () (format "┌%s┐" (make-string (- col 2) ?─)))
              (bot () (format "└%s┘" (make-string (- col 2) ?─)))
              (hdr (s) (let* ((h (concat "─── " s " "))
                              (f (make-string (max 0 (- col 2 (length h))) ?─)))
                         (concat "│" h f "│")))
              (row (s) (format "│%-*s│" (- col 2) s)))
      (insert margin (top) gs (top) "\n")
      (insert margin (hdr "Quick Actions") gs (hdr "GET THINGS DONE") "\n")
      (let ((n (max (length acts) (length my/boba-org-files))))
        (dotimes (i n)
          (let* ((a (nth i acts))
                 (o (nth i my/boba-org-files))
                 (l (if a (format " %s %s" (car a) (cadr a)) ""))
                 (r (if o (format " ● %s.org" o) "")))
            (insert margin (row l) gs (row r) "\n"))))
      (insert margin (bot) gs (bot) "\n")))
  (insert "\n"))

(defun my/boba-open-org (name)
  "Open NAME.org from `org-directory'."
  (find-file (expand-file-name (concat name ".org") org-directory)))

(defun my/boba-widget-nav ()
  "Display the keybindings navigation footer box."
  (let* ((inner 62)
         (title "Keybindings & Navigation")
         (r1    "  [1] Home   [2] Files  [3] Notes         [q] Quit")
         (r2    "  [e] Explorer   [t] Toggle Theme"))
    (cl-flet ((bl (s) (concat "│" s (make-string (max 0 (- inner (string-width s))) ?\s) "│")))
      (my/boba--ic (concat "┌ " title " "
                           (make-string (max 0 (- inner (length title) 3)) ?─) "┐"))
      (my/boba--ic (bl r1))
      (my/boba--ic (bl r2))
      (my/boba--ic (concat "└" (make-string inner ?─) "┘")))))

;;; ─── Init ────────────────────────────────────────────────────────────────────

(after! doom-dashboard
  (setq +doom-dashboard-functions
        '(my/boba-widget-image
          my/boba-widget-welcome
          my/boba-widget-quote
          my/boba-widget-columns
          my/boba-widget-nav))

  (map! :map +doom-dashboard-mode-map
        :n "f" #'find-file
        :n "p" #'projectile-switch-project
        :n "e" #'+treemacs/toggle
        :n "t" #'doom/toggle-theme
        :n "q" #'save-buffers-kill-emacs
        :n "1" #'+doom-dashboard/open
        :n "2" #'find-file
        :n "3" (cmd! (my/boba-open-org "notes"))
        :n "h" (cmd! (my/boba-open-org "habits"))
        :n "n" (cmd! (my/boba-open-org "notes"))
        :n "j" (cmd! (my/boba-open-org "projects"))
        :n "x" (cmd! (my/boba-open-org "todo"))))
