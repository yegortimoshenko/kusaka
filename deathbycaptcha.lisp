(in-package #:kusaka)

(defparameter *deathbycaptcha-endpoint* "http://api.dbcapi.me/api/captcha")

(defstruct deathbycaptcha-client username password)

(defun get-alist (key alist)
  (cdr (assoc key alist :test #'string=)))

(defun deathbycaptcha-submit (client uri)
  (multiple-value-bind (body)
      (http-request
       *deathbycaptcha-endpoint*
       :method :post
       :redirect nil
       :parameters `(("username" . ,(deathbycaptcha-client-username client))
		     ("password" . ,(deathbycaptcha-client-password client))
		     ("captchafile" . ,(make-in-memory-input-stream
				        (http-request uri :user-agent :explorer)))))
    (get-alist "captcha" (url-decode-params body))))

(defun deathbycaptcha-check (id)
  (let* ((body (http-request (concatenate 'string *deathbycaptcha-endpoint* "/" id)))
 	 (text (get-alist "text" (url-decode-params body))))
    (if (not (string= "" text)) text)))

(defun deathbycaptcha-report (client id)
  (http-request
   (concatenate 'string *deathbycaptcha-endpoint "/" id "/report")
   :method :post
   :parameters `(("username" . ,(deathbycaptcha-client-username client))
		 ("password" . ,(deathbycaptcha-client-password client)))))
