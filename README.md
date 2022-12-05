<div align="center">

<img src="./.github/logo.png" height="150px" width="150px"/>

low-level, and zero dependencies Racket web server

Rackever

</div>

---

__This project is still under active development__

## Start
```racket
(route/register-html-handle
 #:path ""
 #:handle (lambda (request-info query in out)
            (display
             (xexpr->string '(html (head (title "Hello")) (body "Hi!")))
             out)))
```

run test with `racket test.rkt`:
```
| Monday, December 5th, 2022 9:49:57pm  [INFO    ]      register a html handle on  with #<procedure:...e/rackever/test.rkt:9:10>
| Monday, December 5th, 2022 9:49:57pm  [INFO    ]      starting server on port 8080
| Monday, December 5th, 2022 9:49:57pm  [INFO    ]      server start complete
Press enter to exit server

| Monday, December 5th, 2022 9:49:59pm  [INFO    ]      server down
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
