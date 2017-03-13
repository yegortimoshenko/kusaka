(in-package #:kusaka)

(defparameter *cleverbot-uri* "http://www.cleverbot.com")

(defmacro cr (path list)
  (let ((counterparts '(#\A car #\D cdr)))
    (reduce #'(lambda (form char) (cons (getf counterparts char) (list form)))
	    (nreverse (coerce (symbol-name path) 'list)) :initial-value list)))

(defun cleverbot-secret ()
  (let* ((endpoint (concatenate 'string *cleverbot-uri* "/extras/conversation-social-min.js"))
	 (response (parse-js (octets-to-string (http-request* endpoint)))))
    `(:query ,(caddr (traverse '("ep" :string) response))
      :stops ,(>> response
		  (traverse '(:assign :+ (:name "d") (:call (:name "md5"))))
		  (cr addaaddaddd)
		  (mapcar #'cadr)))))

(defclass cleverbot ()
  ((cookie-jar :initform (make-instance 'cookie-jar))
   (log :initform '())
   (secret :initform (cleverbot-secret))
   (session :initform "")))

(defmethod initialize-instance :after ((client cleverbot) &key)
  (http-request *cleverbot-uri* :cookie-jar (slot-value client 'cookie-jar)))

(defun md5 (s)
  (>> (ascii-string-to-byte-array s)
      (digest-sequence :md5)
      (byte-array-to-hex-string)))

(defmethod say ((client cleverbot) &optional (phrase ""))
  (with-slots (cookie-jar log secret session) client
    (multiple-value-bind (body status headers)
	(let* ((params `(("stimulus" . ,phrase)
			 ("islearning" . "1")
			 ("icognoid" . "wsf")			
			 ("sessionid" . ,session)
			 ,@(loop for i below (length log) collect
			     (cons (format nil "vText~d" (+ 2 i)) (nth i log)))))
	       (digest (md5 (apply #'subseq (url-encode-params params) (getf secret :stops)))))
	  (http-request* (concatenate 'string *cleverbot-uri* "/webservicemin?" (getf secret :query))
			 :cookie-jar cookie-jar :method :post
			 :parameters (append params `(("icognocheck" . ,digest)))))
      (declare (ignore body status))
      (when-let* ((reply (get-alist :CBOUTPUT headers))
		  (reply (url-decode reply)))
	(setf session (get-alist :CBCONVID headers))
	(setf log (cons reply (cons phrase log)))
	(identity reply)))))

(defclass cleverbot-api ()
  ((state :initform "")
   (token :initarg :token)))

(defmethod say ((client cleverbot-api) &optional (phrase ""))
  (with-slots (state token) client
    (when-let* ((params `(("cs" . ,state)
			  ("input" . ,phrase)
			  ("key" . ,token)))
		(endpoint (concatenate 'string *cleverbot-uri* "/getreply"))
		(response (parse-json (http-request* endpoint :parameters params))))
      (setf state (getf response :|cs|))
      (getf response :|output|))))
