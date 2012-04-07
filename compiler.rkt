#lang racket

(require racket/cmdline
         "lexer.rkt"
         "parser.rkt"
         "sem-ana.rkt"
         "code-gen.rkt")

(code-gen (sem-ana (objc-parser (get-lexgen-file (vector-ref (current-command-line-arguments) 0)))))
