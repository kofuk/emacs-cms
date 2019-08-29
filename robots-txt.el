#!/usr/bin/env elscript
;;; robots-txt.el --- robotx.tst              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(header-status 200 "OK")
(header-content-type "text/plain")
(header-end)

(princ (concat "Sitemap: http" (if config-https-capable "s" "") "://" config-domain-name "/sitemap.xml\n"))

;;; robots-txt.el ends here
