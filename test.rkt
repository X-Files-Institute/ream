#lang racket/base

(require "src/server.rkt"
         "src/route.rkt"
         xml)

(route/register-html-handle
 #:path ""
 #:handle (lambda (request-info query in out)
            (display
             (xexpr->string '(html (head (title "Hello")) (body "Hi!")))
             out)))

(define stop-server (server/start))

(displayln "Press enter to exit server")

(define ignore (read-line))
(stop-server)
