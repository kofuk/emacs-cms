#!/usr/bin/env elscript
;;; main.el --- Bootstrap for Emacs-CMS              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(princ-list "Status: 200 OK")
(princ-list "Content-Type: text/html\n")

(princ-list "<!doctype html>")
(princ-list "<html>")
(princ-list "<head>")
(princ-list "  <meta charset=\"utf-8\">")
(princ-list "  <title>Hello</title>")
(princ-list "</head>")
(princ-list "<body>")
(princ-list "  <h1>Hello from Emacs</h1>")
(princ-list "</body>")
(princ-list "</html>")

;;; main.el ends here
