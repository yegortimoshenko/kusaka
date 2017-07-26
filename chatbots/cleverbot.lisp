(in-package #:yegortimoshenko.kusaka/chatbots.cleverbot)

(defparameter *uri* "https://www.cleverbot.com")

(defun secret ()
  "Fetch Cleverbot's client-side JS code, parse it and find constants required for access."
  (let* ((endpoint (concatenate 'string *uri* "/extras/conversation-social-min.js"))
	 (response (parse-js (flexi-streams:octets-to-string (http-request endpoint)))))
    `(:query ,(caddr (traverse '("ep" :string) response))
      :stops ,(>> (traverse '(:assign :+ (:name "d") (:call (:name "md5"))) response)
		  (cr addaaddaddd)
		  (mapcar #'cadr)))))

(defclass client ()
  ((cookie-jar :initform (make-instance 'drakma:cookie-jar))
   (log :initform ())
   (secret :initform (secret))
   (session :initform "")))

(defmethod initialize-instance :after ((client client) &key)
  (http-request *uri* :cookie-jar (slot-value client 'cookie-jar)))

(defmethod say ((client client) phrase)
  (with-slots (cookie-jar log secret session) client
    (multiple-value-bind (body status headers)
	(let* ((params `(("stimulus" . ,phrase)
			 ("islearning" . "1")
			 ("icognoid" . "wsf")			
			 ("sessionid" . ,session)
			 ,@(loop for i below (length log) collect
			     (cons (format nil "vText~d" (+ 2 i)) (nth i log)))))
	       (digest (ironclad:md5 (apply #'subseq (quri:url-encode-params params) (getf secret :stops)))))
	  (http-request (concatenate 'string *uri* "/webservicemin?" (getf secret :query))
		        :cookie-jar cookie-jar :method :post
			:parameters (append params `(("icognocheck" . ,digest)))))
      (declare (ignore body status))
      (when-let* ((reply (get-alist :CBOUTPUT headers))
		  (reply (quri:url-decode reply)))
	(setf session (get-alist :CBCONVID headers))
	(setf log (cons reply (cons phrase log)))
	(identity reply)))))
