(in-package #:yegortimoshenko.kusaka/chatbots.program-o)

(defclass client ()
  ((bot-id :initarg :bot-id :initform 6)
   (state :initform "")
   (uri :initarg :uri :initform "http://api.program-o.com/v2/chatbot/")))

(defmethod say ((client client) phrase)
  (with-slots (bot-id state uri) client
    (let* ((params `(("bot_id" . ,bot-id)
		     ("convo_id" . ,state)
		     ("format" . "json")
		     ("say" . ,phrase)))
	   (endpoint (concatenate 'string uri "?" (quri:url-encode-params params)))
	   (response (jonathan:parse (http-request endpoint))))
      (setf state (getf response :|convo_id|))
      (getf response :|botsay|))))
