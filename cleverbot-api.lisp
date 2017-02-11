(in-package #:kusaka)

(defclass cleverbot-api ()
  ((state :initform "")
   (token :initarg :token)))

(defmethod say ((client cleverbot-api) (phrase string))
  (with-slots (state token) client
    (when-let* ((params `(("cs" . ,state)
			  ("input" . ,phrase)
			  ("key" . ,token)))
		(endpoint (concatenate 'string *cleverbot-uri* "/getreply"))
		(response (parse (http-request* endpoint :parameters params))))
      (setf state (getf response :|cs|))
      (getf response :|output|))))
