#!/usr/bin/env elscript
;;; main.el --- Bootstrap for Emacs-CMS              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(load (concat (file-name-directory load-file-name) "utilities.el"))

(setq path-segments '())

;; divide path string into path-segments list
(with-temp-buffer
  (insert (getenv "REQUEST_URI"))

  ;; Remove path parameter and anchor part
  (goto-char (point-min))
  (dolist (c '("?" "#"))
    (goto-char (point-min))
    (when (search-forward c nil t)
      (goto-char (- (point) 1))
      (kill-line)))

  ;; Start from the end
  (goto-char (point-max))
  (let ((prev (point-max)) (seg ""))
    (while (search-backward "/" nil t)
      ;; Now, point is just before slash so move point to
      ;; after the slash and get substring
      (setq seg (buffer-substring (+ (point) 1) prev))
      ;; If the length of segment is zero, this doesn't have
      ;; any meaning, so discard the segment
      (when (> (length seg) 0)
        (setq path-segments (append (list seg) path-segments)))
      (setq prev (point)))))

(cond ((= (length path-segments) 0)
       (load (concat (file-name-directory load-file-name) "index.el")))
      ((string= (nth 0 path-segments) "entry")
       (pop path-segments)
       (load (concat (file-name-directory load-file-name) "entry.el")))
      (t
       (load (concat (file-name-directory load-file-name) "not-found-handler.el"))))

;;; main.el ends here
