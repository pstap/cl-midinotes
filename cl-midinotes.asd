;;;; cl-midinotes.asd

(asdf:defsystem #:cl-midinotes
  :description "Library for generating MIDI notes from a human-readable form"
  :author "Peter Stapleton <pstap92@gmail.com>"
  :license "MIT"
  :serial t
  :components ((:file "package")
			   (:file "cl-midinotes")))

