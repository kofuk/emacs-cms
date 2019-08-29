#!/usr/bin/env elscript
;;; main.el --- Bootstrap for Emacs-CMS              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(load (concat (file-name-directory load-file-name) "config.el"))
(load (concat (file-name-directory load-file-name) "utilities.el"))
(load (concat (file-name-directory load-file-name) "config-verifier.el"))

(setq path-segments '())
(setq path-parameters '())

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

;; Parse query string
(setq key "")
(setq value "")

(with-temp-buffer
  ;; Add '&' to make the parse easier
  (insert "&")
  (insert (getenv "QUERY_STRING"))
  (goto-char (point-max))
  (while (search-backward "&" nil t)
    (let (key-begin)
      (setq key-begin (+ (point) 1))

      ;; Search for '='
      ;; If found, parse the parameter as key=value format
      ;; else, parse the parameter as key-only parameter.
      (if (search-forward "=" nil t)
          (progn
            (setq key (buffer-substring key-begin (- (point) 1)))
            (setq value (buffer-substring (point) (point-max))))
        (setq key (buffer-substring key-begin (point-max)))
        (setq value ""))

      ;; Move point to just before the '&'
      (goto-char (- key-begin 1)))

    ;; Delete parsed part
    (kill-line)
    (add-to-list 'path-parameters (cons key value))))


(cond ((= (length path-segments) 0)
       (load (concat (file-name-directory load-file-name) "index.el")))
      ((string= (nth 0 path-segments) "entry")
       (pop path-segments)
       (load (concat (file-name-directory load-file-name) "entry.el")))
      ((and (= (length path-segments) 1) (string= (nth 0 path-segments) "sitemap.xml"))
       (load (concat (file-name-directory load-file-name) "sitemap.el")))
      ((and (= (length path-segments) 1) (string= (nth 0 path-segments) "robots.txt"))
       (load (concat (file-name-directory load-file-name) "robots-txt.el")))
      (t
       (load (concat (file-name-directory load-file-name) "not-found-handler.el"))))

;;; main.el ends here
