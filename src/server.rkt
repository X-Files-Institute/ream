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
         xml
         net/url)

#| Takes an IP port number for client connections. |#
(define (server/start port-no)
  (let ([main-cust (make-custodian)])
    (parameterize ([current-custodian main-cust])
      (let ([listener (tcp-listen port-no 5 #t)])
        (letrec ([loop (lambda (listener)
                         (accept-and-handle listener)
                         (loop listener))])
          (let ([server-thread (thread (lambda () (loop listener)))])
            (lambda ()
              (kill-thread server-thread)
              (tcp-close listener))))))))

#| accepts a connection and returns a stream for input from the client, a stream for output to the client. |#
(define (accept-and-handle listener)
  (let ([connection-cust (make-custodian)])
    (custodian-limit-memory connection-cust (* 50 1024 1024))
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
  (let ([request (regexp-match #rx"^GET (.+) HTTP/[0-9]+\\.[0-9]+" (read-line in))])
    (when request
      ;; Discord the rest of the header
      (regexp-match #rx"(\r\n|^)\r\n" in)

      ;; Dispatch
      (let ([xexpr (dispatch (list-ref request 1))])
        (display "HTTP/1.0 200 Okay\r\n" out)
        (display "Server: k\r\nContent-Type: text/html\r\n\r\n" out)
        (display (xexpr->string xexpr) out)))))

(define (dispatch str-path)
  ; Parse the request as a URL:
  (define url (string->url str-path))
  ; Extract the path part:
  (define path (map path/param-path (url-path url)))
  ; Find a handler based on the path's first element:
  (define h (hash-ref dispatch-table (car path) #f))
  (if h
      ; Call a handler:
      (h (url-query url))
      ; No handler found:
      `(html (head (title "Error"))
             (body
              (font ((color "red"))
                    "Unknown page: "
                    ,str-path)))))

(define dispatch-table (make-hash))

(hash-set! dispatch-table "hello"
           (lambda (query)
             `(html (body "Hello, World!"))))

(define (build-request-page label next-url hidden)
  `(html
    (head (title "Enter a Number to Add"))
    (body ([bgcolor "white"])
          (form ([action ,next-url] [method "get"])
                ,label
                (input ([type "text"] [name "number"]
                                      [value ""]))
                (input ([type "hidden"] [name "hidden"]
                                        [value ,hidden]))
                (input ([type "submit"] [name "enter"]
                                        [value "Enter"]))))))

(define (many query)
  (build-request-page "Number of greetings:" "/reply" ""))

(define (reply query)
  (define n (string->number (cdr (assq 'number query))))
  `(html (body ,@(for/list ([i (in-range n)])
                   " hello"))))

(hash-set! dispatch-table "many" many)
(hash-set! dispatch-table "reply" reply)
