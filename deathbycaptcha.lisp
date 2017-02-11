(in-package #:kusaka)

(defparameter *deathbycaptcha-uri* "http://api.dbcapi.me/api")

(defstruct deathbycaptcha-client username password)

(defun deathbycaptcha-credentials (client)
  `(("username" . ,(deathbycaptcha-client-username client))
    ("password" . ,(deathbycaptcha-client-password client))))

(defun deathbycaptcha-submit (client uri)
  (>> (deathbycaptcha-credentials client)
      (acons "captchafile" (make-in-memory-input-stream (http-request* uri)))
      (http-request (concatenate 'string *deathbycaptcha-uri* "/captcha")
		    :redirect nil :method :post :parameters)
      (url-decode-params)
      (get-alist "captcha")))

(defun deathbycaptcha-check (id)
  (>> (http-request (format nil "~A/captcha/~d" *deathbycaptcha-uri* id))
      (url-decode-params)
      (get-alist "text")))

(defun deathbycaptcha-report (client id)
  (http-request (format nil "~A/captcha/~d/report" *deathbycaptcha-uri* id)
		:method :post :parameters (deathbycaptcha-credentials client)))

(defun deathbycaptcha-balance (client)
  (>> (http-request (concatenate 'string *deathbycaptcha-uri* "/user")
		    :method :post :parameters (deathbycaptcha-credentials client))
      (url-decode-params)
      (get-alist "balance")))
