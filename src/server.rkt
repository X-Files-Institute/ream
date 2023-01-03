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
         "config.rkt"
         "handle.rkt"
         "logger.rkt")

#| Start the server, the parameter is the configuration structure of the server. |#
(define (server/start [config config/default])
  (log/info (format "starting server on ~a:~a" (config/struct-ip config) (config/struct-port config)))
  (let ([main-cust (make-custodian)])
    ;; Limit the total memory used by the server
    (custodian-limit-memory main-cust (config/struct-memory-limit config))
    
    (parameterize ([current-custodian main-cust])
      (let ([listener (tcp-listen (config/struct-port config) 5 #f (config/struct-ip config))])
        (letrec ([loop (λ (listener)
                         (handle/accept listener #:connection-memory-limit (config/struct-connection-memory-limit config))
                         (loop listener))])
          (let ([server-thread (thread (λ () (loop listener)))])
            (log/info "server start complete")
            (λ ()
              (log/info "server down")
              (kill-thread server-thread)
              (tcp-close listener))))))))

(provide server/start)
