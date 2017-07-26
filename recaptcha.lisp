(in-package #:kusaka)

(defparameter *recaptcha-uri* "http://www.google.com/recaptcha/api")

(defun recaptcha-challenge (key)
  (let* ((endpoint (concatenate 'string *recaptcha-uri* "/challenge"))
	 (response (parse-js (http-request endpoint :parameters `(("k" . ,key))))))
    (caddr (traverse '("challenge" :string) response))))

(defun recaptcha-uri (challenge)
  (concatenate 'string *recaptcha-uri* "/image?"
	       (url-encode-params `(("c" . ,challenge)))))
