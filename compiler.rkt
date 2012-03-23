#lang racket

(require racket/cmdline
         "lexer.rkt"
         "parser.rkt")

(objc-parser (get-lexgen-file (vector-ref (current-command-line-arguments) 0)))
