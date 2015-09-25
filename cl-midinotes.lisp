;;;; cl-midinotes.lisp

(in-package #:cl-midinotes)

;;; "cl-midinotes" goes here. Hacks and glory await!

(defparameter *base-midi-values*
  (list '(#\C 0) '(#\D 2) '(#\E 4) '(#\F 5) '(#\G 7) '(#\A 9) '(#\B 11))
  "The value of chromatic scale notes at octave 0")

(defun valid-note? (note)
  "Returns true if the note name is in the chromatic scale. (A-G)"
  (and (char>= note #\A) (char<= note #\G)))

(defun incidental? (char)
  "Returns true if the character is either a sharp (#) or flat (b)"
  (or (eq char #\#) (eq char #\b)))


(defun lookup-note-value (char &optional (notes *base-midi-values*))
  "Look up the value of MIDI note represented as a char in the list, returns the value at octave -2. Returns NIL if the note is not found."
  (if (not notes) ; empty list
	  NIL ; return NIL if empty list
	  (if (char= char (first (first notes))) ; if the note is found
		  (second (first notes)) ; return it's value
		  ; Otherwise look up the rest of the list
		  (lookup-note-value char (cdr notes)))))

(defun parse-note-value (note)
  "Check to see if a note name is valid. If it is look it up in the table and return"
  (if (not (valid-note? note))
	  NIL
	  (lookup-note-value note)))

(defun incidental-value (char)
  "Returns 1 if character is a sharp, -1 if character is a flat"
  (if (not (incidental? char)) nil
	  (if (eq char #\#)
		  +1
		  -1)))

(defun parse-incidentals (note &optional (place 0) (value 0))
  "Return the combined value of all the incidentals"
  (if (not (incidental? (first note)))
	  (cons value place)
	  (parse-incidentals
	   (rest note)
	   (+ 1 place)
	   (+ (incidental-value (first note)) value))))

(defun parse-octave (str pos)
  "Parses the octave beginning from pos (which should be the end of the incidentals"
  (let ((substr (subseq str pos)))
	(if (= (length substr) 0)
		0
		(parse-integer (subseq str pos)))))

(defun string->list (str)
  (loop :for c :across str :collect c))

(defun note->midi (str)
  (let* ((sym-list (string->list str))
		 (note-value (parse-note-value (first sym-list)))
		 (incidental-info (parse-incidentals (rest sym-list)))
		 (octave (parse-octave str (+ 1 (cdr incidental-info)))))
	(+ note-value (car incidental-info) (* 12 octave))))

(defun make-chord (root chord-type)
  (let ((root-num (note->midi root)))
	(cond
	  ((equal chord-type "M") (list root-num (+ root-num 4) (+ root-num 7)))
	  ((equal chord-type "m") (list root-num (+ root-num 3) (+ root-num 7)))
	  ((equal chord-type "m7") (list root-num (+ root-num 3) (+ root-num 7) (+ root-num 9)))
	  (t NIL))))

(defun midi->freq (midi-note)
  (let ((base-freq 8.1757989156))
	(* base-freq (expt 2 (/ midi-note 12)))))

(defun note->freq (note)
  (midi->freq (note->midi note)))
