#!/usr/bin/env elscript
;;; config-verifier.el --- Check if config is set              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(defun config-diag (missing-key)
  (princ (concat "Warning: \"" missing-key "\" is missing in your config file.\n") #'external-debugging-output))

(unless (boundp 'config-blog-name)
  (config-diag "config-blog-name")
  (setq config-blog-name "Sample Blog"))

(unless (boundp 'config-index-template-path)
  (config-diag "config-index-template-path")
  (setq config-index-template-path "template/index.html"))

(unless (boundp 'config-https-capable)
  (config-diag "config-https-capable")
  (setq config-https-capable nil))

(unless (boundp 'config-domain-name)
  (config-diag "config-domain-name")
  (setq config-domain-name "example.com"))

;;; config-verifier.el ends here
