(in-package #:kusaka)

(defclass alice ()
  ((bot-id :initarg :bot-id :initform "b69b8d517e345aba")
   (uri :initarg :uri :initform "http://sheepridge.pandorabots.com")
   (customer-id :initform "")))

(defmethod say ((client alice) &optional (phrase ""))
  (with-slots (bot-id customer-id uri) client
    (let* ((params `(("botid" . ,bot-id)
		     ("custid" . ,customer-id)
		     ("input" . ,phrase)))
	   (endpoint (concatenate 'string uri "/pandora/talk-xml"))
	   (response (parse-xml (http-request* endpoint :parameters params))))
      (setf customer-id (attribute (first-element response) "custid"))
      (if-let (that (first (get-elements-by-tag-name response "that")))
	(text that)))))

(defclass mitsuku (alice)
  ((bot-id :initform "f326d0be8e345a13")
   (uri :initform "https://kakko.pandorabots.com")))
