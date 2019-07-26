#!/usr/bin/env elscript
;;; utilites.el --- Utilities              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(defun header-status (code msg)
  "Print status line for CGI"
  (princ (concat "Status: " (number-to-string code) " " msg "\n")))

(defun header-entry (key value)
  "Print HTTP header entry with specified key and value"
  (princ (concat key ": " value "\n")))

(defun header-content-type (type)
  "Print HTTP header to indicate content type"
  (header-entry "Content-Type" type))

(defun header-html ()
  "Print HTTP header to indicate body is text/html"
  (header-content-type "text/html"))

(defun header-end ()
  (princ "\n"))

(defun not-found ()
  (load (concat (file-name-directory load-file-name) "not-found-handler.el")))

(defun get-entry-title (entry)
  (with-temp-buffer
    (insert-file-contents (concat (file-name-directory load-file-name)
                                  "posts/" entry "/post.org") nil 0 100)
    (goto-char (point-min))
    (if (search-forward "#+TITLE:" nil t)
        (progn
          (let ((title-start (point)))
            (move-end-of-line 1)
            (buffer-substring title-start (point))))
      "No Title")))

;;; entry.el ends here
