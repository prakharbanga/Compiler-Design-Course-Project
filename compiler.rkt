#lang racket

(require racket/cmdline
         "lexer.rkt"
         "parser.rkt"
         "semantic.rkt")

(semantic (objc-parser (get-lexgen-file (vector-ref (current-command-line-arguments) 0))))
