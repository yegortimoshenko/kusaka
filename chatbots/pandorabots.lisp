(in-package #:yegortimoshenko.kusaka/chatbots.pandorabots)

(defclass client ()
  ((bot-id :initarg :bot-id)
   (uri :initarg :uri)
   (customer-id :initform "")))

(defmethod say ((client client) phrase)
  (with-slots (bot-id customer-id uri) client
    (let* ((params `(("botid" . ,bot-id)
		     ("custid" . ,customer-id)
		     ("input" . ,phrase)))
	   (endpoint (concatenate 'string uri "/pandora/talk-xml"))
	   (response (plump:parse (http-request endpoint :parameters params))))
      (setf customer-id (plump:attribute (plump:first-element response) "custid"))
      (if-let (that (first (plump:get-elements-by-tag-name response "that")))
	(plump:text that)))))
