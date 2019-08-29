#!/usr/bin/env elscript
;;; sitemap.el --- Sitemap generator              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(header-status 200 "OK")
(header-content-type "application/xml")
(header-end)

(defun print-sitemap-entry (location file-path)
  (princ "  <url>\n")
  (princ (concat "    <loc>" (make-url-abs location) "</loc>\n"))
  (princ (concat "    <lastmod>"
                 (shell-command-to-string
                  (concat "cd -- \"" (file-name-directory (concat (file-name-directory load-file-name) file-path))
                          "\"&&git log -n 1 --date=format:'%Y-%m-%d' --pretty=format:%cd -- \"" (file-name-nondirectory file-path) "\""))
                 "</lastmod>\n"))
  (princ "  </url>\n"))

(defun make-url-abs (path)
  (concat "http"
          (if config-https-capable "s" "")
          "://"
          config-domain-name
          path))

(princ "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
(princ "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n")

(print-sitemap-entry "/" config-index-template-path)
(print-sitemap-entry "/entry" config-index-template-path)

(let ((dirent (directory-files
               (concat (file-name-directory load-file-name) "posts/")
               nil "^[^._].+$" nil)))
  (dolist (ent dirent)
    (print-sitemap-entry (concat "/entry/" ent) (concat "posts/" ent "/post.org"))))


(princ "</urlset>\n")

;;; sitemap.el ends here
