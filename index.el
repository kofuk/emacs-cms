#!/usr/bin/env elscript
;;; index.el --- Top page handler              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(header-status 200 "OK")
(header-html)
(header-end)
(with-temp-buffer
  (insert-file-contents (concat (file-name-directory load-file-name) config-index-template-path))
  (if (search-forward "{{recent-post}}" nil t)
      (progn (replace-match "")
             (load (concat (file-name-directory load-file-name) "recent-post.el"))
             (insert (recent-post-html))))
  (princ (buffer-string)))

;;; index.el ends here
