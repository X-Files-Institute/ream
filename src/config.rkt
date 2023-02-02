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

#lang typed/racket

#| Default maximum memory usage per connection : 5MB |#
(: DEFAULT_CONNECTION_MEMORY_LIMIT Real)
(define DEFAULT_CONNECTION_MEMORY_LIMIT (* 5 1024 1024))

#| Default server maximum memory usage : 500MB |#
(: DEFAULT_SERVER_MEMORY_LIMIT Real)
(define DEFAULT_SERVER_MEMORY_LIMIT (* 100 DEFAULT_CONNECTION_MEMORY_LIMIT))

#| Default server port |#
(: DEFAULT_SERVER_PORT Real)
(define DEFAULT_SERVER_PORT 8080)

#| Default server ip |#
(: DEFAULT_SERVER_IP String)
(define DEFAULT_SERVER_IP "127.0.0.1")

(struct config/struct ([ip : String] [port : Real] [memory-limit : Real] [connection-memory-limit : Real]))

#| Server default configuration
|| IP used by default : 127.0.0.1
|| Port number used by default : 8080
|| Default server maximum memory usage : 500MB
|| Default maximum memory usage per connection : 5MB |#
(: config/default config/struct)
(define config/default
  (config/struct
   DEFAULT_SERVER_IP
   DEFAULT_SERVER_PORT
   DEFAULT_SERVER_MEMORY_LIMIT
   DEFAULT_CONNECTION_MEMORY_LIMIT))

(provide (all-from-out)
         (all-defined-out))
