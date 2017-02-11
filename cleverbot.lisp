(in-package #:kusaka)

(defun md5 (s)
  (>> (ascii-string-to-byte-array s)
      (digest-sequence :md5)
      (byte-array-to-hex-string)))

(defparameter *cleverbot-uri* "http://www.cleverbot.com")

(defclass cleverbot ()
  ((cookie-jar :initform (make-instance 'cookie-jar))
   (log :initform '())
   (session :initform "")
   (uuid :initform (make-v1-uuid))))

(defmethod initialize-instance :after ((client cleverbot) &key)
  (http-request *cleverbot-uri* :cookie-jar (slot-value client 'cookie-jar)))

(defmethod say ((client cleverbot) (phrase string))
  (with-slots (cookie-jar log session uuid) client
    (multiple-value-bind (body status headers)
	(let* ((params `(("stimulus" . ,phrase)
			 ("islearning" . "1")
			 ("icognoid" . "wsf")			
			 ("sessionid" . ,session)
			 ,@(loop for i below (length log) collect
			     (cons (format nil "vText~d" (+ 2 i)) (nth i log)))))
	       (digest (md5 (subseq (url-encode-params params) 9 35))))
	  (http-request* (concatenate 'string *cleverbot-uri* "/webservicemin?"
			   (url-encode-params `(("uc" . "777") ("botapi" . ,uuid))))
			 :cookie-jar cookie-jar :method :post
			 :parameters (append params `(("icognocheck" . ,digest)))))
      (declare (ignore body status))
      (when-let* ((reply (get-alist :CBOUTPUT headers))
		  (reply (url-decode reply)))
	(setf session (get-alist :CBCONVID headers))
	(setf log (cons reply (cons phrase log)))
	(identity reply)))))
