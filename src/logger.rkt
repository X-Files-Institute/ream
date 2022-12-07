;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rackever                                                                       ;;
;;                                                                                ;;
;; MIT License                                                                    ;;
;;                                                                                ;;
;; Copyright (c) 2022 muqiuhan                                                    ;;
;;                                                                                ;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy   ;;
;; of this software and associated documentation files (the "Software"), to deal  ;;
;; in the Software without restriction, including without limitation the rights   ;;
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      ;;
;; copies of the Software, and to permit persons to whom the Software is          ;;
;; furnished to do so, subject to the following conditions:                       ;;
;;                                                                                ;;
;; The above copyright notice and this permission notice shall be included in all ;;
;; copies or substantial portions of the Software.                                ;;
;;                                                                                ;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     ;;
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       ;;
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    ;;
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         ;;
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  ;;
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  ;;
;; SOFTWARE.                                                                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#lang racket/base

(require "utils.rkt")

(define (log/debug message)
  (display "| ")
  (parameterize ([foreground-color 'white])
    (color-display (current-time)))
  (parameterize ([foreground-color 'blue])
    (color-display (format "\t[DEBUG  ]\t~a\n" message)))
  (flush-output))

(define (log/info message)
  (display "| ")
  (parameterize ([foreground-color 'white])
    (color-display (current-time)))
  (parameterize ([foreground-color 'green])
    (color-display (format "\t[INFO   ]\t~a\n" message)))
  (flush-output))

(define (log/warning message)
  (display "| ")
  (parameterize ([foreground-color 'white])
    (color-display (current-time)))
  (parameterize ([foreground-color 'yellow])
    (color-display (format "\t[WARNING]\t~a\n" message)))
  (flush-output))

(define (log/error message)
  (display "| ")
  (parameterize ([foreground-color 'white])
    (color-display (current-time)))
  (parameterize ([foreground-color 'red])
    (color-display (format "\t[ERROR  ]\t~a\n" message)))
  (flush-output))

(provide log/debug
         log/info
         log/warning
         log/error)