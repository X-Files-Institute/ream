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

#lang racket

(require racket/match
         racket/date)

;; Color and decoration escape definitions

(define reset "\033[0m")

(define (bkg-color256 code)
  (string-append "\033[48;5;" (number->string code) "m"))

(define (fore-color256 code)
  (string-append "\033[38;5;" (number->string code) "m"))

(define decoration-map
  #hasheq(
   (underline . "\033[4m")
   (bold . "\033[1m")
   (reversed . "\033[7m")))

(define fore-color-map
  #hasheq(
   (black . "\033[30m")
   (red . "\033[31m")
   (green . "\033[32m")
   (yellow . "\033[33m")
   (blue . "\033[34m")
   (magenta . "\033[35m")
   (cyan . "\033[36m")
   (white . "\033[37m")
   (b-black . "\033[30;1m")
   (b-red . "\033[31;1m")
   (b-green . "\033[32;1m")
   (b-yellow . "\033[33;1m")
   (b-blue . "\033[34;1m")
   (b-magenta . "\033[35;1m")
   (b-cyan . "\033[36;1m")
   (b-white . "\033[37;1m")))

(define bkg-color-map
  #hasheq(
   (black . "\033[40m")
   (red . "\033[41m")
   (green . "\033[42m")
   (yellow . "\033[43m")
   (blue . "\033[44m")
   (magenta . "\033[45m")
   (cyan . "\033[46m")
   (white . "\033[47m")
   (b-black . "\033[40;1m")
   (b-red . "\033[41;1m")
   (b-green . "\033[42;1m")
   (b-yellow . "\033[43;1m")
   (b-blue . "\033[44;1m")
   (b-magenta . "\033[45;1m")
   (b-cyan . "\033[46;1m")
   (b-white . "\033[47;1m")))

;; customization parameters

(define background-color (make-parameter ""
                                         (λ (arg) (as-escape-seq #t arg))))

(define foreground-color (make-parameter ""
                                         (λ (arg) (as-escape-seq #f arg))))

(define font-style (make-parameter ""
                                   (λ (arg) (as-style-seq arg))))

(define no-reset (make-parameter #f))

;; implementation

(define (ansi-color? x)
  (or
   (and (integer? x) (<= x 255) (>= x 0))
   (and (symbol? x)  (hash-has-key? fore-color-map x))))

(define (as-escape-seq bkg? arg)
  (define (raise-arg-error)
    (raise-arguments-error 'color
                           "Cannot convert argument to color (not a valid symbol or integer in the 0-255 range)"
                           "color"
                           arg))
  (define map (if bkg? bkg-color-map fore-color-map))
  (match arg
    [(? null?) ""]
    ["" ""]
    [(? symbol? s) (hash-ref map s (λ () (raise-arg-error)))]
    [(? integer? x)
     #:when (and (<= x 255) (>= x 0))
     ((if bkg? bkg-color256 fore-color256) x)]
    [_ (raise-arg-error)]))

(define (as-style-seq arg)
  (define (raise-arg-error)
    (raise-arguments-error 'style
                           "Cannot convert argument to style (not a valid symbol)"
                           "style"
                           arg))
  (match arg
    ["" ""]
    [(? null?) ""]
    [(? symbol? s) (hash-ref decoration-map s (λ () (raise-arg-error)))]
    [_ (raise-arg-error)]))

(define (needs-reset? bkg fore style)
  (cond [(no-reset) #f]
        [else (not (and (equal? "" bkg)
                        (equal? "" fore)
                        (equal? "" style)))]))

(define (color-display datum [out (current-output-port)])
  (let* ([bkg (background-color)]
         [fore (foreground-color)]
         [style (font-style)]
         [-reset (if (needs-reset? bkg fore style) reset "")])
    (display (string-append bkg fore style datum -reset) out)))

(define (color-displayln datum [out (current-output-port)])
  (color-display datum out)
  (newline out))

(define with-colors
  (case-lambda
    [(bkg-color fore-color proc)
     (parameterize ([background-color bkg-color]
                    [foreground-color fore-color]
                    [no-reset #t])
       (color-display "") ; sets the colors in the terminal
       (proc)
       (display reset))]  ; reset colors in the terminal
    [(fore-color proc)
     (with-colors null fore-color proc)]))

(define (current-time)
  (date->string (seconds->date (current-seconds)) #t))

(provide current-time
         color-display
         color-displayln
         ansi-color?
         with-colors
         background-color
         foreground-color)
