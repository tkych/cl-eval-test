Last modified : 2013-07-29 19:36:22 tkych

version 0.0.01 (alpha)

(currently, this project is not a library, rather a technique for testing)


Eval-Test: `#+et (=>? form want)`
=================================
 
Introduction
------------

When we make a program, roughly speaking, we have two development styles:

1. Water Fall Development Style: coding then testing,
2. Test Driven Development Style: testing then coding.


In both style, we have to write at least two files, 1. source code file, 2. test code file.
Since there are two separeting files,
if you modify the one file, then you also have to modify the another file for consistancy.

Therefore, there are cost for switching files (*src <-> test*), and potentially mismuch possibility (*src /~ test*).

 (You might insist that we can make one file which contains source at top part and tests at bottom part,
so only one file exists. However, as far as these parts are separating, above logic applied too.)

The goal of Eval-Test is to unify coding phase with testing phase in development cycle.

Including tests in source code, we can reduce the cost of switching files and the mismuch possibility in both styles.
Moreover, since test implies that how the program should work, the source code becomes more readable.


Example
-------

In file [cl-eval-test/example1.lisp](https://github.com/tkych/cl-eval-test/blob/master/example2.lisp):

    (eval-when (:compile-toplevel :load-toplevel)      ;Setup1: prelude for Eval-Test
      (defparameter *features-tmp* *features*)         ;
                                                       ;
      ;; (setf *features* (delete :et *features*))     ; If loaded with no error, this line should be commented in,
      (pushnew :et *features*)                         ; and this line should be commented out.
      )                                                ;

    #+et                                               ;Setup2: define eval-tests
    (eval-when (:compile-toplevel :load-toplevel)      ;
      (defmacro =>? (form want &optional test-fn)      ;
        `(assert (funcall ,(if test-fn test-fn ''equal);
                      ,form ,want)))                   ;
      )                                                ;


    (defun deep-thought (the-answer-of-what)                     ;Source Part
      (let ((d (loop :for char :across the-answer-of-what :collect (char-code char))))
        (+ (* (reduce #'logand d)   (reduce #'logorc1 d))
           (* (reduce #'lognand d)  (reduce #'logorc2 d))
           (* (reduce #'logandc2 d) (reduce #'logior d))
           (* (reduce #'logandc1 d)
              (- (reduce #'logxor d) (reduce #'logeqv d))) (reduce #'lognor d))))


    #+et (=>? (deep-thought "Life, the Universe and Everything") ;Test Part
              42)                                                ;
    #+et (=>? (deep-thought "The Value of Love")                 ;
              52)                                                ;
    #+et (=>? (deep-thought "The Value of Money")                ;
              18885)                                             ;


    (eval-when (:compile-toplevel :load-toplevel)                ;Cleanup for Eval-Test
      (setf *features* *features-tmp*))                          ;


If `(load (compile-file #p"example1.lisp"))`, then no error, good!, otherwise some tests fail.
If you use slime, just C-c C-k in example1.lisp buffer.

For more examples, please see
[cl-eval-test/example2.lisp](https://github.com/tkych/cl-eval-test/blob/master/example2.lisp), or
[cl-date-time-parser/date-time-parser.lisp](https://github.com/tkych/cl-date-time-parser/blob/master/date-time-parser.lisp).


Note
----

 * When program is released, it must be ensured that all cl system does not contain `:et` in `*features*`.
 * It must be ensured that eval test symbols (e.g. `=>?`) is not used in source part.
 * The function which is contained in `#+et form` must be called after its definition.
 * If program loaded with no error, the code `(pushnew :et *features*)` (above Setup1) should be comment out.
 * Eval-Test Setup1,2 must be after package definition.


TODO
----

 * Librarization, (et:enable-et-syntax) (?using cl-annot `#+et -> @et`)
 * To catch the error position, quickly. position message.
 * The function which is contained in `#+et form` enable to be called before its definition code.
 * Check: cl systems other than sbcl.
 * Check: Library dependency.
 * Make: way of system test. currently, one file test only.
 * Add: weave, tangle


Reference
---------

 * D. Knuth "Literate Programming", The Computer Journal, Vol.27, No.2, 1984.
   available at http://www.literateprogramming.com/knuthweb.pdf


Author, License
---------------

- Takaya OCHIAI  <#.(reverse "moc.liamg@lper.hcykt")>

- Public License

- Eval-Test is made with secret E.T. technology.
