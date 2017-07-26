(in-package #:yegortimoshenko.kusaka/chatbots.cleverbot-api)

(defclass client ()
  ((state :initform "")
   (token :initarg :token)))

(defmethod say ((client client) phrase)
  (with-slots (state token) client
    (when-let* ((params `(("cs" . ,state)
			  ("input" . ,phrase)
			  ("key" . ,token)))
		(endpoint (concatenate 'string yegortimoshenko.kusaka/chatbots.cleverbot::*uri* "/getreply"))
		(response (jonathan:parse (http-request endpoint :parameters params))))
      (setf state (getf response :|cs|))
      (getf response :|output|))))
