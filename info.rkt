#lang info
(define collection "ream")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/rackever.scrbl" ())))
(define pkg-desc "low-level, and zero dependencies racket web server")
(define version "0.1.0")
(define pkg-authors '(Muqiu Han))
(define license '(MIT))