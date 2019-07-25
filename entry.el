#!/usr/bin/env elscript
;;; entry.el --- Show entry              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  Koki Fukuda

;; Author: Koki Fukuda <ko.fu.dev@gmail.com>

;; Licensed under the AGPL v3 or later.

;;; Code:

(princ-list
 "Status: 200 OK
Content-Type: text/html

<!doctype html>
<html>
<head>
  <title>Entry</title>
</head>
<body>
  <h1>" path-segments "</h1>
</body>
</html>")

;;; entry.el ends here
