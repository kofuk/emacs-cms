#!/usr/bin/env elscript
;;; entry.el --- Show entry              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(setq entry-id "")

(defun custom-image-export (path desc format)
  (if (eq format 'html)
      (if desc
          (format "<img src=\"/images/%s/%s\" alt=\"%s\">" entry-id path desc)
        (format "<img src=\"/images/%s/%s\">" entry-id path))))

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
    ;;    (setq org-html-postamble nil)
    (setq org-html-postamble "<div class=\"postamble\">Last Update: %d {{recent-post}}</div>")
    (setq org-html-head-include-default-style nil)
    (setq org-html-head-include-scripts nil)
    (setq org-export-with-toc nil)
    (setq org-export-with-author nil)
    (setq org-export-default-language "ja")
    (org-add-link-type "img" nil 'custom-image-export)

    (org-html-export-as-html)
    (switch-to-buffer "*Org HTML Export*")

    ;; Insert recent post section
    (load (concat (file-name-directory load-file-name) "recent-post.el"))
    (goto-char (point-min))
    (search-forward "{{recent-post}}" nil t)
    (replace-match "")
    (insert (recent-post-html))

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

(defun entry-list (page)
  "Return a entry list for page"
  (let ((dirent (directory-files
                 (concat (file-name-directory load-file-name) "posts/")
                 nil "^[^.].+$" nil)))
    (reverse dirent)))

(defun get-entry-date (entry)
  "Return created date of entry according to entry id."
  (if (string-match-p "^[0-9]{8}" entry)
      (with-temp-buffer
        (insert entry)
        (forward-char 4)
        (insert "/")
        (forward-char 2)
        (insert "/")
        (forward-char 2)
        (kill-line)
        (buffer-string))
    ""))

(defun serve-entry-listing (page)
  (with-temp-buffer
    (insert-file-contents (concat (file-name-directory load-file-name) "template/entry-listing.html"))
    (goto-char (point-min))
    (while (search-forward "{{page}}" nil t)
      (replace-match (number-to-string page)))
    (goto-char (point-min))
    (search-forward "{{content}}")
    (replace-match "")

    ;; write entries
    (insert "<table class=\"entries\" cellpadding=\"20\">\n")
    (dolist (ent (entry-list page))
      (insert (format "<tr class=\"entry-row\"><td><a href=\"/entry/%s\">%s</a></td><td>%s</td></tr>\n" ent (get-entry-title ent) (get-entry-date ent))))
    (insert "</table>\n")

    (princ-list (buffer-string))))

;; Entry router
(cond
 ((= (length path-segments) 0)
  (header-status 200 "OK")
  (header-html)
  (header-end)
  (serve-entry-listing
   (if (cdr (assoc "page" path-parameters))
       (string-to-number (cdr (assoc "page" path-parameters)))
     1)))

 ((file-exists-p (concat
                  (file-name-directory load-file-name)
                  "posts/"
                  (nth 0 path-segments)
                  "/post.org"))
  (setq entry-id (nth 0 path-segments))
  (serve-entry (concat
                (file-name-directory load-file-name)
                "posts/"
                (nth 0 path-segments)
                "/post.org")))

 (t
  (not-found)))


;;; entry.el ends here
