(defsystem :kusaka
  :depends-on (:drakma :flexi-streams :ironclad :jonathan :uuid :quri)
  :components ((:file "package")
               (:file "cleverbot")
	       (:file "omegle")))
