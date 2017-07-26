(defsystem #:kusaka
  :depends-on (#:alexandria #:drakma #:flexi-streams #:ironclad
	       #:jonathan #:parse-js #:plump #:split-sequence #:quri)
  :components ((:file "package")
	       (:file "alice")
               (:file "cleverbot")
	       (:file "omegle")))
