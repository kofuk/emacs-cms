#!/usr/bin/env elscript
;;; not-found-handler.el --- Deal with 404 error              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(header-status 404 "Not found")
(header-html)
(header-end)
(with-temp-buffer
  (insert-file-contents (concat (file-name-directory load-file-name) "template/not-found.html"))
  (search-forward "{{path}}" nil t)
  (replace-match (format "%s" path-segments))
  (princ (buffer-string)))

;;; not-found-handler.el ends here
