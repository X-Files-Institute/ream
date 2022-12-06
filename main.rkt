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

(require "src/server.rkt"
         "src/route.rkt"
         "src/config.rkt")

(define (Ream/:> start . middlewares)
  (map (lambda (f) (f)) middlewares)
  (start))

(define (Ream/run #:port [port DEFAULT_SERVER_PORT]
                  #:memory-limit [memory-limit DEFAULT_SERVER_MEMORY_LIMIT]
                  #:connection-memory-limit [connection-memory-limit DEFAULT_CONNECTION_MEMORY_LIMIT])
  (lambda ()
    (server/start (config/struct port memory-limit connection-memory-limit))))

(define (Ream/log #:level [level `info])
  (lambda () '()))

(define (Ream/router register-handle . register-handles)
  (lambda ()
    (map (lambda (f) (f)) register-handles)
    (register-handle)))

(define (Ream/get #:path path #:handle handle #:type type)
  (lambda ()
    (route/register #:path path #:handle handle #:type type)))

(provide (all-from-out)
         (all-defined-out))