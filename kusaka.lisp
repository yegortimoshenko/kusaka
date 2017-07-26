(in-package #:kusaka)

(defun strip-dot (s)
  (string-trim '(#\.) s))

(defun lenient (s)
  (string-downcase (strip-dot s)))

(defparameter *settings*
  `(:bypass nil
    :chatbot (make-instance 'cleverbot)
    :cpm 260
    :delays (1/2 1 1 1 1 3/2 3/2 3 4)
    :deviation .15
    :greetings nil
    :interval 3/2
    :pressure 6
    :style lenient
    :topics ()))

(defvar *omegle*)

(defun random-sign (n)
  (random-elt (list n (- n))))

(defun deviate (d n)
  (+ n (random-sign (* n (random d)))))

(defun reply (settings phrase)
  (let ((phrase (funcall *style* phrase)))
    (sleep (deviate (random-elt *delays*)))
    (omegle-request *omegle* :start-typing)
    (sleep (* (/ 60 (deviate *cpm*)) (length phrase)))
    (format t "Kusaka: ~A~%" phrase)
    (omegle-request *omegle* :send-message phrase)))

(defun start (&optional (settings *settings*))
  "This is some messy shit."
  (let ((*omegle* (omegle-connect topics))
	(empty-frames 0)
	(events ())
	(phrase ""))
    (loop named conversation do
      (setf events (omegle-request *omegle* :poll-events))
      (sleep *interval*)
      (loop for (k m) in (omegle-request *omegle* :poll-events) do
        (switch (k :test #'string=)
	  ("commonLikes"
	   (let ((interests (format nil "~{~A~^, ~}" m)))
	     (format t "You both like ~A.~%" interests)
	     (reply (or greeting (say bot interests)))))
	  ("connected" (format *error-output* "Connected!~%"))
	  ("connectionDied"
	   (format *error-output* "Connection died.~%")
	   (return-from conversation))
	  ("error"
	   (if (string= m "Parameter error.")
	       (setf *omegle* (omegle-connect topics))
	       (progn (format *error-output* "~A~%" m)
		      (return-from conversation))))
	  ("gotMessage"
	   (format t "Stranger: ~A~%" m)
	   (setf phrase (concatenate 'string phrase m))
	   (reply (say bot m)))
	  ("recaptchaRejected" (format *error-output* "Incorrect answer to ReCAPTCHA. ~A~%" m))
	  ("recaptchaRequired"
	   (let* ((challenge (recaptcha-challenge m))
		  (id (>> (recaptcha-uri challenge)
			  (http-request*)
			  (deathbycaptcha-submit dbc)))
		  (response))
	     (format *error-output* "You have ~d CAPTCHAs left.~%" (deathbycaptcha-left dbc))
	     (loop until (setf response (deathbycaptcha-check id)) do (sleep *interval*))
	     (omegle-request *omegle* :solve-captcha challenge response)))
	  ("strangerDisconnected"
	   (format t "Stranger disconnected.~%")
	   (return-from conversation))
	  ("waiting" (format *error-output* "Waiting...~%"))))
	(cond ((< pressure (incf empty-frames))
	       (reply (say bot (car (slot-value bot 'log)))))
	      (phrase (reply (say bot phrase)))))
    (omegle-request *omegle* :disconnect)))

(defun stop (&rest args)
  (declare (ignore args))
  (format *error-output* "~%")
  (omegle-request *omegle* :disconnect)
  (exit 1))

(defun main ()
  (let ((*debugger-hook* #'stop)
	(*random-state* (make-random-state t))
	(*style* (random-elt (mapcar #'cdr *styles*))))
    (make-context)
    (do-cmdline-options (option name value source)
      (print (list option name value source)))
    (if (getopt :short-name "h")
	(help)
	(start (remainder)))))
