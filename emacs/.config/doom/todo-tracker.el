;;; todo-tracker.el --- Tasks inbox sidebar for todo.org -*- lexical-binding: t; -*-

;; Auto-opens a right-side panel when visiting todo.org.
;; Expected todo.org structure:
;;   * Inbox          → TODO items shown in INBOX (CAPTURE)
;;   * Next Actions   → NEXT items shown in FOCUS LIST
;;   * Backlog        → TODO items counted in snapshot
;;   * Projects Overview (optional)

(defvar my/todo-file
  (expand-file-name "todo.org" org-directory)
  "Path to the todo org file.")

(defvar my/tt-buffer "*Tasks Inbox*"
  "Buffer name for the tasks inbox sidebar.")

(defvar my/tt-width 32
  "Width of the tasks inbox sidebar in characters.")

;;; ─── Parsing ─────────────────────────────────────────────────────────────────

(defun my/tt-parse ()
  "Parse `my/todo-file'. Returns plist (:inbox LIST :focus LIST :backlog LIST)."
  (when (file-exists-p my/todo-file)
    (let (inbox focus backlog state)
      (with-temp-buffer
        (insert-file-contents my/todo-file)
        (goto-char (point-min))
        (while (not (eobp))
          (let ((line (buffer-substring-no-properties
                       (line-beginning-position) (line-end-position))))
            (cond
             ;; Level-1 heading — set parsing state
             ((string-match "^\\* \\(.*\\)" line)
              (let ((h (string-trim (match-string 1 line))))
                (setq state (cond
                             ((string-match-p "Inbox"    h) 'inbox)
                             ((string-match-p "Next"     h) 'focus)
                             ((string-match-p "Backlog"  h) 'backlog)
                             (t                              nil)))))
             ;; TODO items (Inbox or Backlog)
             ((and (memq state '(inbox backlog))
                   (string-match "^\\*\\* TODO \\(.*\\)" line))
              (let* ((raw   (match-string 1 line))
                     (clean (string-trim
                             (replace-regexp-in-string ":[[:alpha:]_:]+\\s-*$" "" raw))))
                (if (eq state 'inbox)
                    (push clean inbox)
                  (push clean backlog))))
             ;; NEXT items (Focus List)
             ((and (eq state 'focus)
                   (string-match "^\\*\\* NEXT \\(.*\\)" line))
              (let* ((raw   (match-string 1 line))
                     (clean (string-trim
                             (replace-regexp-in-string ":[[:alpha:]_:]+\\s-*$" "" raw))))
                (push clean focus)))))
          (forward-line 1)))
      (list :inbox   (nreverse inbox)
            :focus   (nreverse focus)
            :backlog (nreverse backlog)))))

;;; ─── Rendering ───────────────────────────────────────────────────────────────

(defun my/tt-section (title)
  "Insert a styled section header with trailing rule."
  (insert "\n"
          (propertize title 'face '(:weight bold :inherit font-lock-keyword-face))
          " "
          (make-string (max 1 (- my/tt-width (length title) 2)) ?─)
          "\n\n"))

(defun my/tt-snapshot-row (label count)
  "Insert one row of the Eisenhower snapshot: LABEL dotted to COUNT."
  (let* ((num   (format "%02d" count))
         (avail (- my/tt-width (length label) (length num) 1))
         (dots  (make-string (max 1 avail) ?.)))
    (insert label dots num "\n")))

(defun my/tt-list-item (text)
  "Insert a list item, truncated to sidebar width."
  (let* ((max-len (- my/tt-width 3))
         (label   (if (> (length text) max-len)
                      (concat (substring text 0 (- max-len 3)) "...")
                    text)))
    (insert "> " label "\n")))

(defun my/tt-render ()
  "Render the tasks inbox sidebar buffer."
  (let* ((data    (my/tt-parse))
         (inbox   (plist-get data :inbox))
         (focus   (plist-get data :focus))
         (backlog (plist-get data :backlog))
         (inhibit-read-only t))
    (erase-buffer)
    (setq-local truncate-lines t
                mode-line-format nil)

    ;; ── Header ──────────────────────────────────────────────────────────────
    (insert "\n"
            (propertize "TASKS INBOX" 'face '(:weight bold :height 1.1))
            "\n")
    (insert-text-button "[+] Add Task"
                        'action     (lambda (_) (find-file my/todo-file))
                        'help-echo  "Open todo.org"
                        'follow-link t)
    (insert "\n")

    ;; ── Eisenhower Snapshot ─────────────────────────────────────────────────
    (my/tt-section "EISENHOWER SNAPSHOT")
    (my/tt-snapshot-row "Focus List "   (length focus))
    (my/tt-snapshot-row "Inbox Tasks "  (length inbox))
    (my/tt-snapshot-row "Backlog "      (length backlog))
    (insert "\n")

    ;; ── Focus List (NEXT items) ─────────────────────────────────────────────
    (my/tt-section "FOCUS LIST")
    (if focus
        (dolist (item focus) (my/tt-list-item item))
      (insert "  Nothing in focus.\n"))
    (insert "\n")

    ;; ── Inbox Capture (TODO items) ───────────────────────────────────────────
    (my/tt-section "INBOX (CAPTURE)")
    (if inbox
        (dolist (item inbox) (my/tt-list-item item))
      (insert "  Inbox empty.\n"))

    (setq buffer-read-only t)
    (goto-char (point-min))))

;;; ─── Commands ────────────────────────────────────────────────────────────────

(defun my/tasks-inbox-open ()
  "Open the tasks inbox as a right-side panel."
  (interactive)
  (let ((buf (get-buffer-create my/tt-buffer)))
    (with-current-buffer buf
      (my/tt-render))
    (display-buffer buf
                    `(display-buffer-in-side-window
                      (side . right)
                      (slot . 1)
                      (window-width . ,my/tt-width)
                      (window-parameters
                       (no-delete-other-windows . t))))))

(defun my/tasks-inbox-refresh ()
  "Re-render the tasks inbox if it is open."
  (interactive)
  (when-let ((buf (get-buffer my/tt-buffer)))
    (with-current-buffer buf
      (my/tt-render))))

(defun my/tasks-maybe-open-inbox ()
  "Auto-open tasks sidebar when visiting todo.org."
  (when (and buffer-file-name
             (string= (file-name-nondirectory buffer-file-name) "todo.org"))
    (my/tasks-inbox-open)
    (add-hook 'after-save-hook #'my/tasks-inbox-refresh nil t)))

(add-hook 'org-mode-hook #'my/tasks-maybe-open-inbox)

(map! :leader
      (:prefix ("o" . "open")
       :desc "Tasks inbox" "T" #'my/tasks-inbox-open))
