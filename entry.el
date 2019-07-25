#!/usr/bin/env elscript
;;; entry.el --- Show entry              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(defun export-current-buffer-as-html ()
      ;; Load dracula-theme for better syntax highlight output
    (add-to-list 'custom-theme-load-path
                 (concat
                  (file-name-directory load-file-name)
                  "third_party/theme"))
    (load-theme 'dracula t)

      ;; Search for "#+TITLE:" to append blog name from the beginning of the file
    (goto-char (point-min))
    (while (not (string= (buffer-substring (point) (+ (point) 8)) "#+TITLE:"))
      (next-line))
    (move-end-of-line 1)
    ;; Append blog name
    (insert (concat " | " config-blog-name "\n"))

    ;; Add options at the end of org document header
    (while (string= (buffer-substring (point) (+ (point) 2)) "#+")
      (next-line))
    (insert "#+HTML_HEAD: <link rel=\"stylesheet\" href=\"/res/entry-style.css\">")

    ;; Let's enable org-mode
    (org-mode)

    (setq org-html-doctype "html5")
    (setq org-html-validation-link nil)
    (setq org-html-postamble nil)
    (setq org-html-head-include-default-style nil)
    (setq org-html-head-include-scripts nil)
    (setq org-export-with-toc nil)
    (setq org-export-with-author nil)

    (org-html-export-as-html)
    (switch-to-buffer "*Org HTML Export*")
    (princ (buffer-string)))

(defun serve-entry (name)
  "Serve specified entry. Existence of the file will not be checked."
  (header-status 200 "OK")
  (header-html)
  (header-end)
  (load (concat (file-name-directory load-file-name) "third_party/htmlize.el"))
  (with-temp-buffer
    ;; Load file content into the buffer
    (insert-file-contents name)

    (export-current-buffer-as-html)))

(cond ((= (length path-segments) 0)
       (header-status 200 "OK")
       (header-content-type "text/plain")
       (header-end)
       (princ "TODO: List entries"))
      ((file-exists-p (concat
                       (file-name-directory load-file-name)
                       "posts/"
                       (nth 0 path-segments)
                       "/post.org"))
       (serve-entry (concat
                     (file-name-directory load-file-name)
                     "posts/"
                     (nth 0 path-segments)
                     "/post.org")))
      (t
       (header-status 404 "Not found")
       (header-html)
       (header-end)
       (princ "<!doctype html>
<html>
<head>
  <title>404 Not found</title>
</head>
<body>
  <h1>" path-segments "</h1>
  Specified entry not found
</body>
</html>")))


;;; entry.el ends here
