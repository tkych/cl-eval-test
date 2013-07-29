;;;; Last modified : 2013-07-29 19:33:52 tkych

;; cl-eval-test/example1.lisp


;;====================================================================
;; Eval Test Example 1
;;====================================================================

(in-package :cl-user)

(defpackage #:eval-test-example-1
  (:use :cl))

(in-package #:eval-test-example-1)


;;--------------------------------------------------------------------
;; Eval Test for Deep-Thought
;;--------------------------------------------------------------------

(eval-when (:compile-toplevel :load-toplevel)      ;Setup1: prelude for Eval-Test
  (defparameter *features-tmp* *features*)

  ;; when release, the following line should be comment in.
  ;; (setf *features* (delete :et *features*))

  ;; when release, the following line should be comment out.
  (pushnew :et *features*)
  )


#+et                                               ;Setup2: define eval-tests
(eval-when (:compile-toplevel :load-toplevel)
  (defmacro =>? (form want &optional test-fn)
    `(assert (funcall ,(if test-fn test-fn ''equal)
                      ,form ,want)))
  )


;;--------------------------------------------------------------------
;; Main
;;--------------------------------------------------------------------

;; Source Part

(defun deep-thought (the-answer-of-what)
  (Let ((d (loop :for char :across the-answer-of-what :collect (char-code char))))
    (+ (* (reduce #'logand d)   (reduce #'logorc1 d))
       (* (reduce #'lognand d)  (reduce #'logorc2 d))
       (* (reduce #'logandc2 d) (reduce #'logior d))
       (* (reduce #'logandc1 d)
          (- (reduce #'logxor d) (reduce #'logeqv d))) (reduce #'lognor d))))


;; Test Part

#+et (=>? (deep-thought "Life, the Universe and Everything")
          42)
#+et (=>? (deep-thought "The Value of Love")
          52)
#+et (=>? (deep-thought "The Value of Money")
          18885)


;; Cleanup for Eval-Test
(eval-when (:compile-toplevel :load-toplevel)
  (setf *features* *features-tmp*))


;;====================================================================
