(in-package #:yegortimoshenko.kusaka/chatbots.mitsuku)

(defclass client (yegortimoshenko.kusaka/chatbots.pandorabots:client)
  ((bot-id :initform "f326d0be8e345a13")
   (uri :initform "https://kakko.pandorabots.com")))
