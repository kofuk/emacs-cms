#!/usr/bin/env elscript
;;; entry.el --- Show entry              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(defun serve-entry (name)
  "Serve specified entry. Existence of the file will not be checked."
  (header-status 200 "OK")
  (header-html)
  (header-end)
  (with-temp-buffer
    (insert-file-contents name)
    (org-mode)
    (setq org-html-doctype "html5")
    (setq org-html-validation-link nil)
    (setq org-html-postamble nil)
    (setq org-export-with-toc nil)
    (setq org-export-with-author nil)
    (org-html-export-as-html)
    (switch-to-buffer "*Org HTML Export*")
    (princ (buffer-string))))

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
