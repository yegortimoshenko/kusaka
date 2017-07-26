(in-package #:yegortimoshenko.kusaka/walk)

(defun allp (coll)
  "True if all elements in COLL are truthy."
  (loop for el in coll always el))

(defun plistp (x)
  "True if X is a proper list."
  (and (listp x)
       (listp (cdr x))))

(defun startp (x y)
  "True if list X is a prefix of Y."
  (if (and (plistp x) (plistp y))
      (all (mapcar #'equal x y))
    (equal x y)))

(defun repeatedly (fun n init)
  (if (zerop n) init
    (funcall fun (repeatedly fun (1- n) init))))

(defun traverse (keys tree)
  (when (consp tree)
    (if (loop for n below (length keys) always
	  (startp (nth n keys)
		  (car (repeatedly #'cdr n tree))))
	tree
	(or (traverse keys (car tree))
	    (traverse keys (cdr tree))))))
