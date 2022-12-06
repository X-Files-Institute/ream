#lang info
(define collection "ream")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/rackever.scrbl" ())))
(define pkg-desc "low-level, and zero dependencies racket web server")
(define version "0.0.2")
(define pkg-authors '(MuqiuHan))
(define license '(MIT))
