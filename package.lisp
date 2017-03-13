(defpackage kusaka
  (:shadow #:http-request #:null #:parse #:traverse #:url-encode)
  (:use #:cl))

(in-package #:kusaka)

(eval-when (:compile-toplevel :execute :load-toplevel)
  (defun dependencies (system)
    (slot-value (asdf:find-system system) 'asdf/component:sideway-dependencies))
  (mapcar #'use-package (dependencies :kusaka)))

(defmacro >> (&rest forms)
  (reduce #'(lambda (xs x) (append x (list xs))) forms))

(defmacro defalias (target source)
  `(setf (fdefinition ',target) #',source))

(defalias parse-json jonathan:parse)
(defalias parse-xml plump:parse)

(defun get-alist (key alist)
  (cdr (assoc key alist :test #'equal)))

(defmacro http-request* (url &rest options)
  `(drakma:http-request ,url ,@options
		        :external-format-out :utf-8
		        :url-encoder #'(lambda (s e) (quri:url-encode s :encoding e))
		        :user-agent :explorer))

(defgeneric say (client &optional phrase))

(defun repeatedly (fun n val)
  (if (zerop n)
      val
      (funcall fun (repeatedly fun (1- n) val))))

(defun startp (x y)
  (if (and (listp x) (listp y))
      (loop for p in (mapcar #'equal x y) always p)
      (equal x y)))

(defun traverse (keys tree)
  (when (consp tree)
    (if (loop for n below (length keys) always
	     (startp (nth n keys)
		     (car (repeatedly #'cdr n tree))))
	tree
	(or (traverse keys (car tree))
	    (traverse keys (cdr tree))))))
