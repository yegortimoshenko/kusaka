(defsystem #:kusaka
  :depends-on (#:alexandria #:net.didierverna.clon #:drakma #:flexi-streams
	       #:ironclad #:jonathan #:parse-js #:plump #:split-sequence #:quri)
  :components ((:file "package")
               (:file "cleverbot")
	       (:file "deathbycaptcha")
	       (:file "omegle")))
