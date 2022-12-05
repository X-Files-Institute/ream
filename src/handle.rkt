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

(require racket/tcp
         racket/match
         "request.rkt"
         "route.rkt"
         "http-status-code.rkt"
         "response.rkt")

#| accepts a connection and returns a stream for input from the client, a stream for output to the client. |#
(define (handle/accept listener #:connection-memory-limit connection-memory-limit)
  (let ([connection-cust (make-custodian)])

    ;; Limit the memory used by each connection
    (custodian-limit-memory connection-cust connection-memory-limit)
    
    (parameterize ([current-custodian connection-cust])
      (let-values ([(in out) (tcp-accept listener)])
        (let* ([connection-thread (thread
                                   (lambda ()
                                     (handle in out)
                                     (close-input-port in)
                                     (close-output-port out)))]
               [watcher-thread (thread
                                (lambda ()
                                  (sleep 10)
                                  (custodian-shutdown-all connection-cust)))])
          watcher-thread)))))

#| handle a connection |#
(define (handle in out)
  (let ([request-info (request/get-info in #:info-type 'header)])
    (when request-info
      (let ([handle (route/dispatch (list-ref request-info 1))])
        (handle request-info in out)))))

(provide handle/accept)
