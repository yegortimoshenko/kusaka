(in-package #:kusaka)

(defsynopsis (:postfix "INTERESTS...")
  (enum
   :short-name "b" :long-name "bot"
   :argument-name "NAME"
   :description "Set chatbot API (possible values: alice, cleverbot, mitsuku)."
   :enum '(alice cleverbot cleverbot-api mitsuku))
  (lispobj
   :short-name "c" :long-name "cpm"
   :argument-name "NUM"
   :description "Set typing speed (in characters per minute).")
  (stropt
   :short-name "d" :long-name "delays"
   :argument-name "NUMS"
   :description (format nil "Set delays before each reply, chosen at random ~
                             (separated by commas, in seconds)."))
  (lispobj
   :short-name "D" :long-name "deviation"
   :argument-name "NUM"
   :description "Set deviation (must be less than 1).")
  (stropt
   :short-name "g" :long-name "greeting"
   :argument-name "PHRASE"
   :description "Set greeting.")
  (flag
   :short-name "h" :long-name "help"
   :description "Print this message.")
  (lispobj
   :short-name "i" :long-name "interval"
   :argument-name "NUM"
   :description "Set interval between event checks (in seconds).")
  (enum
   :short-name "s" :long-name "style"
   :argument-name "NAME"
   :description "Set punctuation style (possible values: default, dotless, lenient)."
   :enum (mapcar #'car *styles*))
  (stropt
   :long-name "cleverbot"
   :argument-name "TOKEN"
   :description (format nil "When set, uses official Cleverbot API instead of ~
                             reverse-engineered client. See: https://www.cleverbot.com/api"))
  (stropt
   :long-name "deathbycaptcha"
   :argument-name "USER:PASS"
   :description (format nil "When set, uses Death by CAPTCHA for CAPTCHA bypass. ~
                             See: http://deathbycaptcha.com")))
