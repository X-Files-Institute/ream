<div align="center">

<img src="./.github/logo.png" height="150px" width="150px"/>

low-level, and zero dependencies Racket web server

Ream

</div>

---

__This project is still under active development__

## Start
```racket
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
```

## Build and Run

run test with `racket test.rkt`:
```
$ racket test.rkt                  
| Tuesday, December 6th, 2022 8:08:05pm [DEBUG  ]       register a handle on hello with #<procedure:...e/rackever/test.rkt:26:23>
| Tuesday, December 6th, 2022 8:08:05pm [DEBUG  ]       register a handle on  with #<procedure:...e/rackever/test.rkt:22:23>
| Tuesday, December 6th, 2022 8:08:05pm [INFO   ]       starting server on port 8080
| Tuesday, December 6th, 2022 8:08:05pm [INFO   ]       server start complete
| Tuesday, December 6th, 2022 8:08:07pm [INFO   ]       request recevied -> (GET /hello HTTP/1.1 /hello)
| Tuesday, December 6th, 2022 8:08:11pm [INFO   ]       request recevied -> (GET / HTTP/1.1 /)
| Tuesday, December 6th, 2022 8:08:15pm [INFO   ]       server down
```

## License

MIT License

Copyright (c) 2022 Muqiu Han

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
