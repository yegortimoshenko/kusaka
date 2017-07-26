(in-package #:yegortimoshenko.kusaka/chatbots)

(defgeneric say (client phrase)
  (:documentation "Return response to PHRASE from a chatbot (using CLIENT)."))
