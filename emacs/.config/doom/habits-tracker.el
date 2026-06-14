;;; habits-tracker.el --- Habits tracker sidebar -*- lexical-binding: t; -*-

;; Creates a right-side panel when visiting habits.org.
;; Expected habits.org structure:
;;   * Daily Routines
;;   ** Morning Checklist
;;      - [ ] item
;;   * Habits Tracker
;;   ** TODO Habit name   :habit:
;;      SCHEDULED: <date .+Nd>

(defvar my/habits-file
  (expand-file-name "habits.org" org-directory)
  "Path to the habits org file.")

(defvar my/ht-buffer "*Habits Tracker*"
  "Buffer name for the habits tracker sidebar.")

(defvar my/ht-width 32
  "Width of the habits tracker sidebar in characters.")

;;; ─── Parsing ─────────────────────────────────────────────────────────────────

(defun my/ht-parse ()
  "Parse `my/habits-file'. Returns plist (:routines ALIST :habits LIST)."
  (when (file-exists-p my/habits-file)
    (let (routines habits
          state cur-head cur-items)
      (with-temp-buffer
        (insert-file-contents my/habits-file)
        (goto-char (point-min))
        (while (not (eobp))
          (let ((line (buffer-substring-no-properties
                       (line-beginning-position) (line-end-position))))
            (cond
             ;; Level-1 heading — determine section
             ((string-match "^\\* \\(.*\\)" line)
              (when (and cur-head (eq state 'routines))
                (push (cons cur-head (nreverse cur-items)) routines)
                (setq cur-head nil cur-items nil))
              (let ((h (string-trim (match-string 1 line))))
                (setq state (cond
                             ((string-match-p "Daily Routines" h) 'routines)
                             ((string-match-p "Habit"          h) 'habits)
                             (t                                     nil)))))
             ;; Level-2 in Daily Routines
             ((and (eq state 'routines) (string-match "^\\*\\* \\(.*\\)" line))
              (when cur-head
                (push (cons cur-head (nreverse cur-items)) routines))
              (setq cur-head (string-trim (match-string 1 line))
                    cur-items nil))
             ;; Habit TODO entry
             ((and (eq state 'habits) (string-match "^\\*\\* TODO \\(.*\\)" line))
              (let* ((raw   (match-string 1 line))
                     (clean (string-trim
                             (replace-regexp-in-string ":[[:alpha:]_:]+\\s-*$" "" raw))))
                (push clean habits)))
             ;; Checklist item inside a routine subsection
             ((and (eq state 'routines) cur-head
                   (string-match "^[[:space:]]*- \\[.\\] \\(.*\\)" line))
              (push (string-trim (match-string 1 line)) cur-items))))
          (forward-line 1)))
      (when (and cur-head (eq state 'routines))
        (push (cons cur-head (nreverse cur-items)) routines))
      (list :routines (nreverse routines)
            :habits   (nreverse habits)))))

;;; ─── Rendering ───────────────────────────────────────────────────────────────

(defun my/ht-section (title)
  "Insert a styled section header with trailing rule."
  (insert "\n"
          (propertize title 'face '(:weight bold :inherit font-lock-keyword-face))
          " "
          (make-string (max 1 (- my/ht-width (length title) 2)) ?─)
          "\n\n"))

(defun my/ht-sparkline (habit-title bars)
  "Generate a deterministic BARS-wide sparkline keyed by HABIT-TITLE."
  (let* ((blocks "▁▂▃▄▅▆▇█")
         (seed   (cl-reduce #'+ (string-to-list habit-title) :initial-value 0)))
    (mapconcat (lambda (i)
                 (string (aref blocks (% (abs (+ (* seed 3) (* i 11))) 8))))
               (number-sequence 1 bars) "")))

(defun my/ht-render ()
  "Render the habits tracker sidebar buffer."
  (let* ((data     (my/ht-parse))
         (routines (plist-get data :routines))
         (habits   (plist-get data :habits))
         (inhibit-read-only t))
    (erase-buffer)
    (setq-local truncate-lines t
                mode-line-format nil)

    ;; ── Header ──────────────────────────────────────────────────────────────
    (insert "\n"
            (propertize "HABITS TRACKER" 'face '(:weight bold :height 1.1))
            "\n")
    (insert-text-button "[+] Add Habit"
                        'action     (lambda (_) (find-file my/habits-file))
                        'help-echo  "Open habits.org"
                        'follow-link t)
    (insert "\n")

    ;; ── Daily Routines ──────────────────────────────────────────────────────
    (my/ht-section "DAILY ROUTINES")
    (if routines
        (dolist (r routines)
          (insert (propertize (car r) 'face '(:weight bold)) "\n")
          (dolist (item (cdr r))
            (insert "  [ ] " item "\n"))
          (insert "\n"))
      (insert (if (file-exists-p my/habits-file)
                  "  No routines found.\n\n"
                "  habits.org not found.\n\n")))

    ;; ── Habits ──────────────────────────────────────────────────────────────
    (my/ht-section "HABITS")
    (if habits
        (progn
          (dolist (habit habits)
            (let* ((max-title (- my/ht-width 7))
                   (label     (if (> (length habit) max-title)
                                  (concat (substring habit 0 (- max-title 3)) "...")
                                habit)))
              (insert label " 🔥.. ")
              (insert-text-button "↩"
                                  'action    (lambda (_) (find-file my/habits-file))
                                  'help-echo habit
                                  'follow-link t)
              (insert "\n")))
          (insert "\n"))
      (insert "  No habits found.\n\n"))

    ;; ── Trend Sparkline ─────────────────────────────────────────────────────
    (my/ht-section "TREND SPARKLINE")
    (if habits
        (dolist (habit (seq-take habits 4))
          (let* ((word  (car (split-string habit)))
                 (label (truncate-string-to-width word 9 nil ?\s))
                 (spark (my/ht-sparkline habit 6)))
            (insert (format "%-9s  %s\n" label spark))))
      (insert "  No data.\n"))

    (setq buffer-read-only t)
    (goto-char (point-min))))

;;; ─── Commands ────────────────────────────────────────────────────────────────

(defun my/habits-tracker-open ()
  "Open the habits tracker as a right-side panel."
  (interactive)
  (let ((buf (get-buffer-create my/ht-buffer)))
    (with-current-buffer buf
      (my/ht-render))
    (display-buffer buf
                    `(display-buffer-in-side-window
                      (side . right)
                      (slot . 1)
                      (window-width . ,my/ht-width)
                      (window-parameters
                       (no-delete-other-windows . t))))))

(defun my/habits-tracker-refresh ()
  "Re-render the habits tracker if it is open."
  (interactive)
  (when-let ((buf (get-buffer my/ht-buffer)))
    (with-current-buffer buf
      (my/ht-render))))

(defun my/habits-maybe-open-tracker ()
  "Auto-open the tracker sidebar when visiting habits.org."
  (when (and buffer-file-name
             (string= (file-name-nondirectory buffer-file-name) "habits.org"))
    (my/habits-tracker-open)
    (add-hook 'after-save-hook #'my/habits-tracker-refresh nil t)))

(add-hook 'org-mode-hook #'my/habits-maybe-open-tracker)

(map! :leader
      (:prefix ("o" . "open")
       :desc "Habits tracker" "H" #'my/habits-tracker-open))
