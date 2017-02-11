(in-package #:kusaka)

(defun md5 (s)
  (byte-array-to-hex-string
   (digest-sequence :md5
    (ascii-string-to-byte-array s))))

(defparameter *cleverbot-domain* "http://www.cleverbot.com")

(defclass cleverbot-client ()
  ((cookie-jar :initform (make-instance 'cookie-jar))
   (log :initform '())
   (session :initform "")
   (uuid :initform (make-v1-uuid))))

(defmethod initialize-instance :after ((client cleverbot-client) &key)
  (http-request *cleverbot-domain*
		:method :head
		:cookie-jar (slot-value client 'cookie-jar)))

(defun cleverbot-ask (client query)
  (with-slots (cookie-jar log session uuid) client
    (multiple-value-bind (body status headers)
	(let* ((params `(("stimulus" . ,query)
			 ("islearning" . "1")
			 ("icognoid" . "wsf")			
			 ("sessionid" . ,session)))
	       (vtexts (loop for i to (length log)
			  for v in log
			  collect (cons (format nil "vText~d" (+ 2 i)) v)))
	       (params (append params vtexts))
	       (digest (md5 (subseq (url-encode-params params) 9 35)))
	       (params (append params `(("icognocheck" . ,digest)))))
	  (http-request (concatenate 'string *cleverbot-domain* "/webservicemin?"
			  (url-encode-params `(("uc" . "777") ("botapi" . ,uuid))))
			:method :post
			:external-format-out :utf-8
			:cookie-jar cookie-jar
			:user-agent :explorer
			:parameters params
			:url-encoder (lambda (s e) (url-encode s :encoding e))))
      (declare (ignore body))
      (when (= status 200)
	(push query log)
	(loop for (k . v) in headers
	   do (case k (:CBCONVID (setf session v))
		      (:CBOUTPUT (push (url-decode v) log))))
	(first log)))))
