(in-package #:kusaka)

(defparameter *omegle-servers*
  (loop for n from 1 to 16 collect (format nil "front~d.omegle.com" n)))

(defun char-range (from to)
  (loop for n from (char-code from) to (char-code to) collect (code-char n)))

(defparameter *omegle-randid-alphabet*
  (append (char-range #\0 #\9)
	  (char-range #\A #\Z)))

(defun sample (xs)
  (nth (random (length xs)) xs))

(defun random-string (alphabet length)
  (concatenate 'string (loop repeat length collect (sample alphabet))))

(defun unquote (s) (string-trim '(#\") s))

(defstruct omegle-client id server)

(defun omegle-connect (&optional (topics '()))
  (let ((randid (random-string *omegle-randid-alphabet* 8))
	(server (sample *omegle-servers*)))
    (multiple-value-bind (body status)
	(http-request (concatenate 'string "http://" server "/start")
		      :user-agent :explorer
		      :parameters `(("randid" . ,randid)
				    ,(if topics `("topics" . ,(to-json topics)))))
      (if (= status 200)
	  (make-omegle-client :id (unquote (octets-to-string body))
			      :server server)))))

(defparameter *omegle-actions*
  '((omegle-disconnect "/disconnect")
    (omegle-poll-events "/events")
    (omegle-send-message "/send" (|msg|))
    (omegle-solve-captcha "/recaptcha" (|challenge| |response|))
    (omegle-start-typing "/typing")))

(defmacro omegle-defaction (name path &optional args)
  `(defun ,name (client ,@args)
     (multiple-value-bind (body status)
	 (http-request (concatenate 'string "http://" (omegle-client-server client) ,path)
		       :method :post
		       :user-agent :explorer
		       :parameters `(("id" . ,(omegle-client-id client))
				     ,,@(mapcar (lambda (s) `(cons ,(symbol-name s) ,s)) args)))
       (if (= status 200)
	   (if (stringp body)
	       (identity t)
	       (parse (octets-to-string body :external-format :utf-8)))))))

(dolist (a *omegle-actions*) (eval `(omegle-defaction ,@a)))
