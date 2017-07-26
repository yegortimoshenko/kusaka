(in-package #:yegortimoshenko.kusaka/macros)

(defmacro >> (&rest forms)
  (reduce #'(lambda (xs x) (append x (list xs))) forms))

(defmacro cr (path list)
  (reduce #'(lambda (form char) (cons (getf '(#\A car #\D cdr) char) (list form)))
	  (nreverse (coerce (symbol-name path) 'list)) :initial-value list))

(defmacro pull (key alist)
  `(cdr (assoc ,key ,alist :test #'equal)))

(defmacro http-request (url &rest options)
  `(drakma:http-request
    ,url ,@options
    :external-format-out :utf-8
    :url-encoder #'(lambda (s e) (quri:url-encode s :encoding e))
    :user-agent :explorer))
