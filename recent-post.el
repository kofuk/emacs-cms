#!/usr/bin/env elscript
;;; recent-post.el --- Recent post              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(defun recent-post-html ()
  (with-temp-buffer
    (insert "<div class=\"recent-post-container\">")
    (insert "<h2>Recent Posts</h2>")
    (insert "<table class=\"recent-post-table\" cellpadding=\"10\">")
    (let ((dirent (directory-files
                   (concat (file-name-directory load-file-name) "posts")
                   nil "^[^.].+" nil)) (i 0) (entry ""))
      (setq dirent (reverse dirent))
      (while (and (< i (length dirent)) (< i 3))
        (setq entry (nth i dirent))
        (insert (format "<tr><td><a href=\"/entry/%s\">%s</a></td></tr>" entry (get-entry-title entry)))
        (setq i (+ i 1))))
    (insert "</table></div>")
    (buffer-string)))

;;; recent-post.el ends here
