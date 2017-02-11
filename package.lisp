(defpackage kusaka
  (:use #:alexandria #:cl #:drakma #:flexi-streams #:ironclad #:jonathan #:uuid #:quri)
  (:shadowing-import-from #:cl #:null)
  (:shadowing-import-from #:quri #:url-encode))

(in-package #:kusaka)

(defmacro >> (&rest forms)
  (reduce #'(lambda (xs x) (append x (list xs))) forms))

(defun get-alist (key alist)
  (cdr (assoc key alist :test #'equal)))

(defmacro http-request* (uri &rest options)
  `(http-request ,uri ,@options
		 :external-format-out :utf-8
		 :url-encoder #'(lambda (s e) (url-encode s :encoding e))
		 :user-agent :explorer))

(defgeneric say (client phrase))
