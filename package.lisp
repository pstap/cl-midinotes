;;;; package.lisp

(defpackage #:cl-midinotes
  (:use #:cl)
  (:export #:note->midi
		   #:note->freq
		   #:midi->freq
		   #:make-chord))

