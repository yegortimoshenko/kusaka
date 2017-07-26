(defpackage yegortimoshenko.kusaka/macros
  (:documentation "Various generic shorthands.")
  (:export #:>> #:cr #:http-request #:pull)
  (:use #:cl))

(defpackage yegortimoshenko.kusaka/walk
  (:export #:traverse)
  (:use #:cl))

(defpackage yegortimoshenko.kusaka/bypass.deathbycaptcha
  (:documentation "Death by CAPTCHA API client.")
  (:export #:balance #:check #:make-client #:report #:submit)
  (:use #:yegortimoshenko.kusaka/macros #:cl))

(defpackage yegortimoshenko.kusaka/omegle
  (:documentation "Reverse-engineered Omegle client.")
  (:export #:connect #:make-client #:request)
  (:use #:yegortimoshenko.kusaka/macros
	#:alexandria #:cl))

(defpackage yegortimoshenko.kusaka/chatbots
  (:export #:say)
  (:use #:cl))

(defpackage yegortimoshenko.kusaka/chatbots.alice
  (:documentation "A.L.I.C.E. client (powered by Pandorabots), see http://alice.pandorabots.com")
  (:export #:client)
  (:use #:yegortimoshenko.kusaka/chatbots #:cl))

(defpackage yegortimoshenko.kusaka/chatbots.cleverbot
  (:documentation "Reverse-engineered Cleverbot client.")
  (:export #:client)
  (:use #:yegortimoshenko.kusaka/chatbots
   	#:yegortimoshenko.kusaka/macros
	#:yegortimoshenko.kusaka/walk
        #:alexandria #:cl #:parse-js))

(defpackage yegortimoshenko.kusaka/chatbots.cleverbot-api
  (:documentation "Cleverbot API client, see https://www.cleverbot.com/api/")
  (:export #:client)
  (:use #:yegortimoshenko.kusaka/chatbots
	#:yegortimoshenko.kusaka/macros
	#:alexandria #:cl))

(defpackage yegortimoshenko.kusaka/chatbots.mitsuku
  (:documentation "Mitsuku client (powered by Pandorabots), see http://www.mitsuku.com")
  (:export #:client)
  (:use #:yegortimoshenko.kusaka/chatbots #:cl))

(defpackage yegortimoshenko.kusaka/chatbots.pandorabots
  (:documentation "Reverse-engineered generic Pandorabots client.")
  (:export #:client)
  (:use #:yegortimoshenko.kusaka/chatbots
	#:yegortimoshenko.kusaka/macros
	#:alexandria #:cl))

(defpackage yegortimoshenko.kusaka/chatbots.program-o
  (:documentation "Program-O APIv2 client, see http://www.program-o.com/chatbotapi")
  (:export #:client)
  (:use #:yegortimoshenko.kusaka/chatbots
	#:yegortimoshenko.kusaka/macros
	#:alexandria #:cl))

(defpackage yegortimoshenko.kusaka/chatbots.santabot
  (:documentation "Santabot client, see http://www.santabot.com")
  (:export #:client)
  (:use #:yegortimoshenko.kusaka/chatbots
	#:yegortimoshenko.kusaka/macros
	#:alexandria #:cl))
