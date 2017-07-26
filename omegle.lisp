(in-package #:yegortimoshenko.kusaka/omegle)

(defparameter *servers*
  (loop for n from 1 to 32 collect (format nil "front~d.omegle.com" n)))

(defun char-range (from to)
  (loop for n from (char-code from) to (char-code to) collect (code-char n)))

(defparameter *randid-alphabet*
  (append (char-range #\2 #\9)
	  (char-range #\A #\Z)))

(defun random-string (alphabet length)
  (concatenate 'string (loop repeat length collect (random-elt alphabet))))

(defstruct client id server)

(defun connect (&optional topics)
  (let* ((params `(("rcs" . "1")
		   ("randid" . ,(random-string *randid-alphabet* 8))
		   ("topics" . ,(jonathan:to-json topics))
		   ("spid" . "")))
	 (server (random-elt *servers*))
	 (endpoint (format nil "http://~A/start" server))
	 (response (http-request endpoint :parameters params)))
    (make-client :id (string-trim '(#\") (flexi-streams:octets-to-string response)) :server server)))

(defparameter *actions*
  '(:disconnect    ("/disconnect")
    :poll-events   ("/events")
    :send-message  ("/send" . ("msg"))
    :solve-captcha ("/recaptcha" . ("challenge" "response"))
    :start-typing  ("/typing")))

(defun request (client type &rest args)
  (let* ((action (getf *actions* type))
	 (params (acons "id" (client-id client) (mapcar #'cons (cdr action) args)))
	 (endpoint (concatenate 'string "http://" (client-server client) (car action)))
	 (response (drakma:http-request endpoint :method :post :parameters params)))
    (if (not (stringp response))
	(jonathan:parse (flexi-streams:octets-to-string response :external-format :utf-8)))))
