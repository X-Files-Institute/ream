#lang racket/base

(require xml
         "src/logger.rkt"
         "main.rkt")

(define (hello info)
  (xexpr->string `(html
                   (head
                    (title "Hello"))
                   (body
                    (h1 ,(format "Hello ~a!" info))))))

(define server-handle
  (Ream/:>
   (Ream/run #:port 8080
             #:connection-memory-limit (* 5 1024 1024)
             #:memory-limit (* 500 1024 1024))
   (Ream/log #:level 'debug)
   (Ream/router
    (Ream/get #:path ""
              #:type 'html
              #:handle (λ (request-info query in out)
                         (display (hello "Ream") out)))
    (Ream/get #:path "hello"
              #:type 'html
              #:handle (λ (request-info query in out)
                         (display (hello "world") out))))))

(define x (begin (log/warning "Press enter to exit server!") (read-line)))
(server-handle)