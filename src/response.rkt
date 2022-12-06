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

(require racket/match
         "http-status-code.rkt")

#| Unknown HTTP response type |#
(define-struct Unknow-HTTP-Response-Type-Exn (type))

#| Add http response header |#
(define (response/add-type [type 'html])
  (format "Server: k\r\nContent-Type: ~a\r\n\r\n"
          (match type
            ['html "text/html"]
            [_ (raise (Unknow-HTTP-Response-Type-Exn type))])))

#| Respond with a 502 status code and display the message |#
(define (response/502 message out)
  (display (response/add-type 'html) out)
  (display message out)
  (display (http-status-code/build-status-info 'bad-gateway) out))

(provide (all-defined-out))
