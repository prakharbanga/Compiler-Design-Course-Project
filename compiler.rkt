#lang racket

(require racket/cmdline
         "lexer.rkt"
         "parser.rkt"
         "semantic.rkt")

(begin (semantic (objc-parser (get-lexgen-file (vector-ref (current-command-line-arguments) 0)))) (newline) (display cur_sym_tab) (newline))
