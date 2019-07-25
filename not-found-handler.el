#!/usr/bin/env elscript
;;; not-found-handler.el --- Deal with 404 error              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(princ-list
 "Status: 404 Not Found
Content-Type: text/html

<!doctype html>
<html>
<head>
  <title>Not Found</title>
</head>
<body>
  <h1>" path-segments " Not Found</h1>
</body>
</html>")

;;; not-found-handler.el ends here
