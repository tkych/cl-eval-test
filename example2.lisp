;;;; Last modified : 2013-07-29 19:33:19 tkych

;; cl-eval-test/example2.lisp


;;====================================================================
;; Eval Test Example 2
;;====================================================================

(in-package :cl-user)

(defpackage #:eval-test-example-2
  (:use :cl))

(in-package #:eval-test-example-2)


;;--------------------------------------------------------------------
;; Eval Test for Example 2
;;--------------------------------------------------------------------

;; Setup1: prelude for Eval-Test

(eval-when (:compile-toplevel :load-toplevel)
  (defparameter *features-tmp* *features*)

  ;; when release, the following line should be comment in.
  ;; (setf *features* (delete :et *features*))
  
  ;; when release, the following two lines should be comment out.
  (ql:quickload :alexandria)
  (pushnew :et *features*)
  )


;; Setup2: define eval-tests

#+et
(eval-when (:compile-toplevel :load-toplevel)
  
  (defmacro =>? (form want &optional test)
    "Check whether FORM is evaluated to WANT by TEST (default is `equal`).
If first element of WANT is `:values`, then check mutiple values."
    (if (and (listp want) (eq :values (first want)))
        `(assert (funcall ,(if test test ''equal)
                          (multiple-value-list ,form)
                          (list ,@(rest want))))
        `(assert (funcall ,(if test test ''equal)
                          ,form ,want))))

  (defmacro =>t? (form)
    "Check whether FORM is evaluated to T."
    `(=>? ,form t))
  
  (defmacro =>nil? (form)
    "Check whether FORM is evaluated to NIL."
    `(=>? ,form nil))
  
  (defmacro p>? (form want)
    "Check whether FORM prints WANT as string.
Examples:
  (p>? (princ 42) \"42\") => NIL
  (p>? (print 42) \"42\") => error! ;print outputs newline"
    (let ((s (gensym)))
      `(=>? (with-output-to-string (,s)
              (let ((*standard-output* ,s))
                ,form))
            ,want #'string=)))
  
  (defmacro f>? (file want)
    "Check whether content of FILE is same as content of WANT.
Examples:
  (f>? #p\"./foo.lisp\" #p\"./foo.lisp\")      => NIL
  (f>? #p\"./foo.lisp\" #p\"./not-foo.lisp\")  => error!"
    `(=>? (alexandria:read-file-into-string ,file)
          (alexandria:read-file-into-string ,want)
          #'string=))
  
  ) ;end of #+et eval-when


;;--------------------------------------------------------------------
;; Main
;;--------------------------------------------------------------------

(defun foo (x y)
  (values (+ x y) (- x y)))

#+et (=>? (foo 1 2) 3)
#+et (=>? (foo 1 2) (:values 3 -1))


(defun baz (x y)
  (= x y))

#+et (=>t?   (baz 1 1))
#+et (=>nil? (baz 1 2))


(defun bar (x y)
  (princ (+ x y)))

#+et (p>? (bar 1 2) "3")



;; Cleanup for Eval-Test
(eval-when (:compile-toplevel :load-toplevel)
  (setf *features* *features-tmp*))


;;====================================================================
