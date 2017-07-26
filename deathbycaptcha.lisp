(in-package #:yegortimoshenko.kusaka/deathbycaptcha)

(defparameter *endpoint* "http://api.dbcapi.me/api")

(defstruct client username password)

(defun credentials (client)
  `(("username" . ,(client-username client))
    ("password" . ,(client-password client))))

(defun request (client uri &optional params)
  (quri:url-decode-params
   (http-request (concatenate 'string *endpoint* uri)
		 :parameters (append params (if client (credentials client)))
		 :redirect nil)))

(defun submit (client octets)
  (>> (request client "/captcha" '(("captchafile" . ,(flexi-streams:make-in-memory-input-stream octets))))
      (get-alist "captcha")))

(defun check (id)
  (get-alist "text" (request nil id (format nil "/captcha/~d" id))))

(defun ensure (p &rest args)
  (if (apply p args)
      (values-list args)))

(defun check (id)
  (>> (http-request (format nil "~A/captcha/~d" *uri* id))
      (url-decode-params)
      (get-alist "text")
      (ensure (compose #'not #'emptyp))))

(defun report (client id)
  (http-request (format nil "~A/captcha/~d/report" *uri* id)
		:method :post :parameters (credentials client)))

(defun status (client)
  (request "/user"))
